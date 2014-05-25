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

  def test_namespaced_cache
    Noodles.cache.set(:sessions, {})

    assert_equal Hash.new, Noodles.cache.get(:sessions)

    sessions = Noodles.cache.get(:sessions)

    damir_session = '312h0urq3'

    damir_info = {user_id: 1, user_name: 'Damir'}

    sessions[damir_session] = damir_info

    Noodles.cache.set(:sessions, sessions)

    assert_equal damir_session, Noodles.cache.get(:sessions).keys.first

    assert_equal damir_info, Noodles.cache.get(:sessions)[damir_session]

    sessions = Noodles.cache.get(:sessions)

    jelena_session = 'AZ3981erQ2'

    jelena_info = {user_id: 2, user_name: 'Jelena'}

    sessions[jelena_session] = jelena_info

    Noodles.cache.set(:sessions, sessions)

    assert_equal jelena_info, Noodles.cache.get(:sessions)[jelena_session]

    assert_equal 2, Noodles.cache.get(:sessions).count

    sessions = Noodles.cache.get(:sessions)

    sessions.delete(jelena_session)

    Noodles.cache.set(:sessions, sessions)

    assert_equal 1, Noodles.cache.get(:sessions).count

    assert_equal damir_info, Noodles.cache.get(:sessions)[damir_session]
  end
end