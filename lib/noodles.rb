# require "noodles/dependencies"
require 'noodles/version'
require 'noodles/utils'
require 'noodles/application'
require 'noodles/environment'
require 'multi_json'

module Noodles

  class << self
    def env
      Environment
    end

    def application
      return @@application if defined? @@application
      @@application = Noodles::Application.new
    end

    def http_app
      return @@http_app if defined? @@http_app
      @@http_app = application.http_app
    end

    def websocket_app
      return @@websocket_app if defined? @@websocket_app
      @@websocket_app = application.websocket_app
    end
  end

end