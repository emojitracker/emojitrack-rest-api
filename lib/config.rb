require 'redis'

# db setup -- checks for REDIS_URL by default, or fallback to localhost
REDIS = Redis.new()
