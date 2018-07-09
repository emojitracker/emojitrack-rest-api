require "sinatra/base"
require "rack-cache"
require "oj"
require "emoji_data"

class WebAPI < Sinatra::Base
  before do
    headers("Access-Control-Allow-Origin" => "*")
  end

  get "/details/:char" do
    cache_control :public, max_age: 30

    emoji_char = EmojiData.find_by_unified(params[:char])
    emoji_char_rank = REDIS.ZREVRANK("emojitrack_score", emoji_char.unified).to_i + 1
    emoji_tweets = REDIS.LRANGE("emojitrack_tweets_#{emoji_char.unified}", 0, 9)
    emoji_tweets_json = emoji_tweets.map! { |t| Oj.load(t) }
    
    details = {
      "char" => emoji_char.char({variant_encoding: true}),
      "name" => emoji_char.name,
      "id" => emoji_char.unified,
      "details" => {
        "variations" => emoji_char.variations,
        "short_name" => emoji_char.short_name,
        "short_names" => emoji_char.short_names,
        "text" => emoji_char.text,
      },
      "popularity_rank" => emoji_char_rank,
      "recent_tweets" => emoji_tweets_json,
    }

    content_type :json
    Oj.dump(details)
  end

  get "/rankings" do
    cache_control :public, max_age: 10

    raw_scores = REDIS.zrevrange("emojitrack_score", 0, -1, {withscores: true})
    scores = raw_scores.map do |score|
      emo_obj = EmojiData.find_by_unified(score[0])
      {
        "char" => emo_obj.char({variant_encoding: true}),
        "id" => emo_obj.unified,
        "name" => emo_obj.name,
        "score" => score[1].to_i,
      }
    end

    content_type :json
    Oj.dump(scores)
  end

  get "/stats" do
    raw_score = REDIS.zrevrange("emojitrack_score", 0, -1, {withscores: true})
                      .map { |s| s[1] }
                      .inject(:+)
                      .to_i
    Oj.dump({"raw_score" => raw_score})
  end

  get "/status" do
    content_type :json
    begin
      raise "Unexpected response" if REDIS.ping != "PONG"
    rescue Exception => e
      status 500
      Oj.dump({"error" => "Error communicating with database."})
    else
      status 200
      Oj.dump({"ok" => true})
    end
  end
end
