require "noodles/version"

module Noodles
  class Application
    def call(env)
      [200, {'Content-Type' => 'text/html'}, ["Hello from Ruby on Noodles!"]]
    end
  end
end