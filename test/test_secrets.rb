require_relative 'test_helper'

class TestApp < Noodles::Application
  def secrets_path
    File.join('test', 'secrets.yml')
  end
end

class SecretsTest < Minitest::Test

  def app
    TestApp.new
  end

  def test_facebook_id
    ENV['NOODLE_FB_SECRET'] = 'xyz'
    assert_equal 'xxx', app.secrets.facebook_id
    assert_equal 'xyz', app.secrets.facebook_secret
  end

  def test_facebook_id_on_production_env
    ENV['RACK_ENV'] = 'production'
    ENV['NOODLE_FB_SECRET'] = 'zxy'
    assert_equal 'zzz', app.secrets.facebook_id
    assert_equal 'zxy', app.secrets.facebook_secret
    ENV['RACK_ENV'] = 'test'
  end
end