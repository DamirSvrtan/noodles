require 'rack/websocket'

module Noodles
  module Websocket
    class Handler < Rack::WebSocket::Application

      @@connections ||= []

      # def connection
      #   @websocket_handler.instance_variable_get("@connection")
      # end

      def add_connection handler
        @@connections << handler
      end


      def remove_connection handler
        @@connections.delete handler
      end

      def broadcast msg
        @@connections.each do |connection|
          connection.send_data msg
        end
      end

      def request(env)
        Rack::Request.new(env)
      end

      def params(env)
        request(env).params
      end

      def connection_storage

      end
    end
  end
end