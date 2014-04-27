require 'rack/websocket'

module Noodles
  module Websocket
    class Handler < Rack::WebSocket::Application


      def connection
        @websocket_handler.instance_variable_get("@connection")
      end
    end
  end
end