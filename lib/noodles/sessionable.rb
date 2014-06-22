require 'noodles/memcached_session'
module Noodles
  module Sessionable
    def session
      @session ||= Noodles.use_memached_as_session_storage ? Noodles::MemcachedSession.new(@env) : @env['rack.session']
    end
  end
end