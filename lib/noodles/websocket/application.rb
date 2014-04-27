require "noodles/websocket/routing"
require "noodles/websocket/handler"

module Noodles
  module Websocket
    class Application
      def call(env)
        handler = get_handler(env)
        handler.call(env)
      end
    end
  end
end