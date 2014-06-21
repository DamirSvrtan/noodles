require 'rack/websocket'

module Noodles
  module Websocket
    class Handler < Rack::WebSocket::Application

      @@connections ||= []

      def register_connection!
        @@connections << self
      end

      def unregister_connection!
        @@connections.delete self
      end

      alias_method :deregister_method!, :unregister_connection!

      def broadcast msg
        @@connections.each do |connection|
          connection.send_data msg
        end
      end

      def broadcast_but_self msg
        (@@connections - [self]).each do |connection|
          connection.send_data msg
        end
      end

      def request(env)
        Rack::Request.new(env)
      end

      def params(env)
        request(env).params
      end

      def session
        @session
      end
    end
  end
end