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
      if controller.get_response
        format_response(controller.get_response)
      else
        [200, {'Content-Type' => 'text/html'}, [text]]
      end
    end

    def format_response(response)
      [response.status, response.headers, response.body]
    end
  end
end