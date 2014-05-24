require_relative 'test_helper'

Noodles.cache_store_name = 'testing_cache'

describe Minitest::Spec do
  after do
    Noodles.cache.flush
  end
end

class SecretsTest < Minitest::Test

  def test_cache_set
    Noodles.cache.set('user', 'Salvador')
    assert_equal 'Salvador', Noodles.cache.get('user')
  end

  def test_cache_set_hash
    Noodles.cache.set('X_session_id_X', user_id: 1)
    assert_equal 1, Noodles.cache.get('X_session_id_X')[:user_id]
  end
end