source "https://rubygems.org"
ruby "2.7.3"

group :api do
  gem "emoji_data", "~> 0.2.0"
  gem "hiredis", "~> 0.6.1"
  gem "oj", "~> 3.6.3"
  gem "redis", "~> 4.0.1"

  gem "dalli", "~> 2.7.8"
  gem "puma", "~> 4.3.8"
  gem "rack-cache", "~> 1.8.0"
  gem "sinatra", "~> 2.0.3"
end

group :development do
  gem "fasterer", "~> 0.4.1"
  gem "rufo", "~> 0.3.1"
  gem "solargraph", "~> 0.40.4"
end

group :test do
  gem "minitest", "~> 5.11.3"
  gem "minitest-reporters", "~> 1.3.0"
  gem "mocha", "~> 1.5.0"
  gem "rack-test", "~> 1.0.0"
end

group :production do
  gem "newrelic_rpm"
end
