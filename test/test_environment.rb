require_relative 'test_helper'

class NoodlesEnvironmentTest < Minitest::Test

  def test_development
    assert Noodles.env.test?
    assert Noodles.env == :test
    assert Noodles.env == 'test'
    assert Noodles.env.to_s == 'test'
    assert "Noodles environment is #{Noodles.env}", "Noodles environment is test"
  end

  def test_environment
    assert Noodles.env.test?
    refute Noodles.env.production?
    refute Noodles.env.development?
    ENV['RACK_ENV'] = "production"
    assert Noodles.env.production?
    refute Noodles.env.development?
    refute Noodles.env.test?
    ENV['RACK_ENV'] = 'test'
  end
end