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
  end

end