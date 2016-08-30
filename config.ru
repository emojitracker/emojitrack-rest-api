require 'rack-cache'
require 'dalli'
require 'redis'


if memcache_servers = ENV['MEMCACHIER_SERVERS']
  cache = Dalli::Client.new memcache_servers.split(','), {
    username: ENV['MEMCACHIER_USERNAME'],
    password: ENV['MEMCACHIER_PASSWORD']
  }

  use Rack::Cache,
    verbose: true,
    metastore: cache,
    entitystore: cache
end

# deflate output for bandwidth savings
use Rack::Deflater

# db setup -- checks for REDIS_URL by default, or fallback to localhost
REDIS = Redis.new()

require "./web_api"
require "./web_admin"
map('/api/v1/') { run WebAPI }
map('/admin/')  { run WebAdmin }
