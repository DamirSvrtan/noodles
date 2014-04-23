require "noodles/version"
require "noodles/utils"
require "noodles/dependencies"
require "noodles/controller"
require "noodles/routing"
require "noodles/file_model"

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
  end
end