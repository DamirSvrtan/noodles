require_relative 'test_helper'

module Noodles
  def self.secrets_path
    File.join('test', 'secrets.yml')
  end
end

class SecretsTest < Minitest::Test

  def test_facebook_id
    ENV['NOODLE_FB_SECRET'] = 'xyz'
    assert_equal 'xxx', Noodles.secrets.facebook_id
    assert_equal 'xyz', Noodles.secrets.facebook_secret
  end

  def test_facebook_id_on_production_env
    ENV['RACK_ENV'] = 'production'
    ENV['NOODLE_FB_SECRET'] = 'zxy'
    assert_equal 'zzz', Noodles.secrets.facebook_id
    assert_equal 'zxy', Noodles.secrets.facebook_secret
    ENV['RACK_ENV'] = 'test'
  end
end