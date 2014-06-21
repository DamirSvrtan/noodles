module Noodles
  class MemcachedSession

    def initialize(env)
      @env = env
    end

    def session_id
      @env['rack.session']['init'] = true unless @env['rack.session'].loaded?
      @env['rack.session']['session_id']
    end

    def [](key)
      _internal_session_storage[key]
    end

    def []=(key, value)
      session_data = _internal_session_storage
      session_data[key] = value
      Noodles.cache.set(session_id, session_data)
    end

    def delete(key)
      session_data = _internal_session_storage
      session_data.delete(key)
      Noodles.cache.set(session_id, session_data)
    end

    def inspect
      _internal_session_storage
    end

    private

      def _internal_session_storage
        session_data = Noodles.cache.get(session_id)
        if session_data.nil?
          session_data = {}
          Noodles.cache.set(session_id, session_data)
        end
        session_data
      end
  end
end