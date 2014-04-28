require "noodles/http/application"
require "noodles/websocket/application"

module Noodles
  class Application

    attr_reader :http_app, :websocket_app

    def initialize
      @http_app = Noodles::Http::Application.new 
      @websocket_app = Noodles::Websocket::Application.new
    end

    def call(env)
      if env['HTTP_UPGRADE'] == "websocket"
        @websocket_app.call(env)
      else
        @http_app.call(env)
      end
    end
  end
end