# require "noodles/dependencies"
require 'noodles/version'
require "noodles/http/application"
require "noodles/websocket/application"

module Noodles
  class Application
    def call(env)
      if env['HTTP_UPGRADE'] == "websocket"
        Noodles::Websocket::Application.new.call(env)
      else
        Noodles::Http::Application.new.call(env)
      end
    end
  end
end