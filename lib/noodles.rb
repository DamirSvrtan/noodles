# require "noodles/dependencies"
require 'noodles/version'
require 'noodles/utils'
require 'noodles/application'
require 'noodles/environment'
require 'noodles/cache'
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

    def secrets
      rendered_string = Erubis::Eruby.new(File.read(secrets_path)).result
      secrets_hash = YAML.load(rendered_string)[Noodles.env.to_s]
      OpenStruct.new(secrets_hash)
    end

    def secrets_path
      File.join('config', 'secrets.yml')
    end

    def cache
     return @@cache if defined? @@cache
     options = { namespace: "noodle_app", compress: true }
     @@cache = Cache.new('localhost:11211', options)
    end
  end
end