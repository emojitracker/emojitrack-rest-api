source 'https://rubygems.org'
ruby '2.3.1'

group :api do
  gem 'redis', '~> 3.0.7'
  gem 'hiredis', '~> 0.6.0'
  gem 'oj', '~> 2.9.9'
  gem 'emoji_data', '~> 0.2.0'

  gem 'sinatra', '~> 1.4.6'
  gem 'unicorn', '~> 4.8.3'
  gem 'dalli', '~> 2.7.4'
  gem 'rack-cache', '~> 1.5.1'
  gem 'rack-timeout', '~> 0.3.2'
  gem 'memcachier', '~> 0.0.2'
end

group :development do
  gem 'rspec', '~> 2.14.1'
end

group :production do
  gem 'newrelic_rpm'
end
