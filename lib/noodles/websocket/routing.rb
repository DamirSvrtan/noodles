module Noodles
  module Websocket
    class Application
      def get_handler(env)
        _, handler, after = env['PATH_INFO'].split('/', 3)
        handler = handler.capitalize
        handler += 'Handler'
        Object.const_get(handler)
      end
    end
  end
end