require 'redis'
require 'uri'
require 'socket'

#convenience method for reading booleans from env vars
def to_boolean(s)
  s and !!s.match(/^(true|t|yes|y|1)$/i)
end

# verbose mode or no
VERBOSE = to_boolean(ENV["VERBOSE"]) || false

# db setup
REDIS_URI = URI.parse(ENV["REDIS_URL"] || ENV["REDISCLOUD_URL"] || ENV["REDISTOGO_URL"] || ENV["BOXEN_REDIS_URL"] || "redis://localhost:6379")
REDIS = Redis.new(:host => REDIS_URI.host, :port => REDIS_URI.port, :password => REDIS_URI.password, :driver => :hiredis)

# api server setup
def web_api_uri
  # allow to be manually specified in env, which will always override
  return ENV['WEB_API_URI'] if ENV['WEB_API_URI']
  # otherwise, use defaults
  return "http://www.emojitracker.com/api" if is_development_frontend_only?
  "/api"
end

# stream server setup
STREAM_SERVER = ENV['STREAM_SERVER'] || 'http://stream.emojitracker.com'

# environment checks
def is_production?
  ENV["RACK_ENV"] == 'production'
end

def is_development?
  ENV["RACK_ENV"] == 'development'
end

def is_development_frontend_only?
  is_development? && to_boolean(ENV["FRONTEND_ONLY"])
end

# configure logging to graphite in production
def graphite_log(metric, count)
  @hostedgraphite_apikey = ENV['HOSTEDGRAPHITE_APIKEY']
  # puts "Graphite log - #{metric}: #{count}" if VERBOSE
  if is_production?
    sock = UDPSocket.new
    sock.send @hostedgraphite_apikey + ".#{metric} #{count}\n", 0, "carbon.hostedgraphite.com", 2003
  end
end

# same as above but include heroku dyno hostname
def graphite_dyno_log(metric,count)
  dyno = ENV['DYNO'] || 'unknown-host'
  metric_name = "#{dyno}.#{metric}"
  graphite_log metric_name, count
end
