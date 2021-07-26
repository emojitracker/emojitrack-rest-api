# frozen_string_literal: true
require "sinatra/base"
require "rack-cache"
require "oj"
require "emoji_data"
require "net/http"
require "json"
require "erb"
include ERB::Util

class WebAPI < Sinatra::Base
  configure do
    set :raise_errors, false
    set :show_exceptions, false
  end

  before do
    headers("Access-Control-Allow-Origin" => "*")
    content_type :json
  end

  def fetch_details(id)
    REDIS.pipelined do
      @emoji_score = REDIS.ZSCORE("emojitrack_score", id)
      @emoji_rank = REDIS.ZREVRANK("emojitrack_score", id)
      @emoji_tweets = REDIS.LRANGE("emojitrack_tweets_#{id}", 0, 9)
    end
    return @emoji_score.value.to_i,
           @emoji_rank.value.to_i + 1,
           @emoji_tweets.value
  end

  def fetch_scores
    REDIS.zrevrange("emojitrack_score", 0, -1, {withscores: true})
  end

  def fetch_meaning(id, char)
    meaning = REDIS.GET("emojitrack_meaning_#{id}")
    if meaning.nil?
      encoded_char = url_encode char
      url = "https://api.emojipedia.org/emojis/#{encoded_char}/?api_key=#{ENV['EMOJIPEDIA_API_KEY']}&format=json"
      uri = URI(url)
      begin
        response = Net::HTTP.get(uri)
        response = JSON.parse(response)
        meaning = response["description"]
      rescue
        # bad practice to rescue from everything, but we discard
        # anything anyway, if any error happened above
      else
        # cache response for five minutes
        REDIS.SET("emojitrack_meaning_#{id}", meaning)
        REDIS.EXPIRE("emojitrack_meaning_#{id}", 300)
      end
    end
    return meaning
  end

  get "/details/:id" do
    cache_control :public, max_age: 30

    emoji_char = EmojiData.find_by_unified(params[:id])
    if emoji_char.nil?
      halt 404, Oj.dump("error" => "id not found")
    end
    emoji_score, emoji_rank, emoji_tweets = fetch_details(params[:id])
    emoji_tweets_json = emoji_tweets.map! { |t| Oj.load(t) }
    begin
      # TODO get the call to fetch_meaning back into tests and get rid of the
      # begin..rescue block. Currently it will be botched up in tests.
      emoji_meaning = fetch_meaning(params[:id], emoji_char.char({variant_encoding: true}))
    rescue
      emoji_meaning = nil
    end

    details = {
      "char" => emoji_char.char({variant_encoding: true}),
      "name" => emoji_char.name,
      "id" => emoji_char.unified,
      "score" => emoji_score,
      "popularity_rank" => emoji_rank,
      "meaning" => emoji_meaning,
      "details" => {
        "variations" => emoji_char.variations,
        "short_name" => emoji_char.short_name,
        "short_names" => emoji_char.short_names,
        "text" => emoji_char.text,
      },
      "recent_tweets" => emoji_tweets_json,
    }

    Oj.dump(details)
  end

  get "/rankings" do
    cache_control :public, max_age: 10

    raw_scores = fetch_scores()
    scores = raw_scores.map do |score|
      emo_obj = EmojiData.find_by_unified(score[0])
      {
        "char" => emo_obj.char({variant_encoding: true}),
        "id" => emo_obj.unified,
        "name" => emo_obj.name,
        "score" => score[1].to_i,
      }
    end

    Oj.dump(scores)
  end

  get "/stats" do
    raw_score = fetch_scores().map { |s| s[1] }.inject(:+).to_i
    Oj.dump({"raw_score" => raw_score})
  end

  get "/status" do
    begin
      raise "Unexpected response" if REDIS.ping != "PONG"
    rescue
      status 500
      Oj.dump({"error" => "Error communicating with database."})
    else
      status 200
      Oj.dump({"ok" => true})
    end
  end

  error 404 do
    Oj.dump({"error" => "404 Not Found"})
  end

  error 500 do
    Oj.dump({"error" => "Internal Server Error"})
  end
end
