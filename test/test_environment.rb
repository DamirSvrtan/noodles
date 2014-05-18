require_relative 'test_helper'

class NoodlesEnvironmentTest < Minitest::Test

  def test_development
    assert Noodles.env.development?, "Environmet is: #{Noodles.env}"
    assert Noodles.env == :development, "Environmet is: #{Noodles.env}"
    assert Noodles.env == 'development', "Environmet is: #{Noodles.env}"
    assert Noodles.env.to_s == 'development', "Environmet is: #{Noodles.env}"
    assert "Test environment is #{Noodles.env}", "Test environment is development"
  end

  def test_environment
    refute Noodles.env.production?, "Environmet is: #{Noodles.env}"
    refute Noodles.env.test?, "Environmet is: #{Noodles.env}"
    assert Noodles.env.development?, "Environmet is: #{Noodles.env}"
    ENV['RACK_ENV'] = "production"
    assert Noodles.env.production?, "Environmet is: #{Noodles.env}"
    refute Noodles.env.development?, "Environmet is: #{Noodles.env}"
    ENV['RACK_ENV'] = nil
  end
end