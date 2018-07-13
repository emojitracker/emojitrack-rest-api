ENV["RACK_ENV"] = "test"

require "rack/test"
require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "mocha/minitest"

class MiniTest::Spec
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
  include Rack::Test::Methods
end
