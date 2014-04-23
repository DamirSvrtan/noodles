require "noodles/version"
require "noodles/utils"
require "noodles/dependencies"

module Noodles
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      elsif env['PATH_INFO'] == '/'
        return [200, {'Content-Type' => 'text/html'}, ["<h1>Hello!</h1>"]]
      end

      klass, action = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(action)
      [200, {'Content-Type' => 'text/html'}, [text]]
    end

    def get_controller_and_action(env)
        _, controller, action, after = env['PATH_INFO'].split('/', 4)
      controller = controller.capitalize
      controller += 'Controller'
      [Object.const_get(controller), action]
    end
  end

  class Controller
    attr_reader :env
    def initialize(env)
      @env = env
    end
  end

end