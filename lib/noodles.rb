# require "noodles/dependencies"
require 'noodles/version'
require 'noodles/utils'
require 'noodles/application'
require 'multi_json'

module Noodles


  class << self
    def environment?
      ENV['RACK_ENV'] || :development
    end

    def development?
      ENV['RACK_ENV'].to_s == 'development' || ENV['RACK_ENV'].nil?
    end

    def production?
      ENV['RACK_ENV'].to_s == 'production'
    end
    
    def test?
      ENV['RACK_ENV'].to_s == 'test'
    end
  end
end