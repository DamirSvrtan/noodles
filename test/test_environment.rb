require_relative 'test_helper'

class NoodlesEnvironmentTest < Minitest::Test

  def test_development
    assert Noodles.env.development?
    assert Noodles.env == :development
    assert Noodles.env == 'development'
  end

  def test_environment
    refute Noodles.env.production?
    refute Noodles.env.test?
    assert Noodles.env.development?
    ENV['RACK_ENV'] = "production"
    assert Noodles.env.production?
    refute Noodles.env.development?
    ENV['RACK_ENV'] = nil
  end
end