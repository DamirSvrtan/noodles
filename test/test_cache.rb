require_relative 'test_helper'

class SecretsTest < Minitest::Test

  def test_cache_set
    Noodles.cache.set('user', 'Salvador')
    assert_equal 'Salvador', Noodles.cache.get('user')
  end
end