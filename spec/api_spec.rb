require_relative "spec_helper"
require_relative "../web_api"
require_relative "snapshots"

class ApiSpec < Minitest::Spec
  include Rack::Test::Methods

  def app
    WebAPI
  end

  describe "GET /rankings" do
    before do
      app.any_instance.stubs(:fetch_scores).returns(SCORES_SNAPSHOT)
      get "/rankings"
    end

    it "should return as HTTP 200" do
      app.any_instance.stubs(:fetch_scores).returns(SCORES_SNAPSHOT)
      get "/rankings"
      assert last_response.ok?
    end

    it "should be content-type: application/json" do
      app.any_instance.stubs(:fetch_scores).returns(SCORES_SNAPSHOT)
      get "/rankings"
      last_response.content_type.must_equal "application/json"
    end

    it "should contain properly formatted data" do
      app.any_instance.stubs(:fetch_scores).returns(SCORES_SNAPSHOT)
      get "/rankings"
      begin
        scores = JSON.parse(last_response.body)
      rescue JSON::ParserError => e
        assert false, e
      end

      scores.length.must_equal 845
      assert scores.all? { |s| s.keys == ["char", "id", "name", "score"] },
        "response objects contain unexpected keys"
      scores.first["char"].must_be_kind_of String
      scores.first["id"].must_be_kind_of String
      scores.first["name"].must_be_kind_of String
      scores.first["score"].must_be_kind_of Numeric
    end
  end

  describe "GET /details/:id" do
    before do
      app.any_instance.stubs(:fetch_details).returns([123456789, 16, TWEETS_SNAPSHOT.clone])
      get "/details/1F680"
    end

    it "should return as HTTP 200" do
      assert last_response.ok?
    end

    it "should be content-type: application/json" do
      last_response.content_type.must_equal "application/json"
    end

    it "should contain properly formatted data" do
      begin
        details = JSON.parse(last_response.body)
      rescue JSON::ParserError
        assert false
      end

      assert details.keys == ["char", "name", "id", "score", "popularity_rank", "details", "recent_tweets"],
        "response objects contain unexpected keys"
    end
  end
end
