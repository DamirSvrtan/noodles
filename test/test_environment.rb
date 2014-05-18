require_relative 'test_helper'

class NoodlesEnvironmentTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_development
    assert Noodles.env.development?
    assert Noodles.env == :development
    assert Noodles.env == 'development'
  end

  def test_environment
    assert !Noodles.env.production?
    assert !Noodles.env.test?
    assert Noodles.env.development?
    ENV['RACK_ENV'] = "production"
    assert Noodles.env.production?
    assert !Noodles.env.development?
    ENV['RACK_ENV'] = nil
  end
end