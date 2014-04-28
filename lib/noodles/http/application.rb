require "noodles/http/router"
require "noodles/http/controller"

module Noodles
  module Http
    class Application
      def call(env)
        if env['PATH_INFO'] == '/favicon.ico'
          return [404, {'Content-Type' => 'text/html'}, []]
        end
        rack_app = get_rack_app(env)
        rack_app.call(env)
      end

      def routes(&block)
        @router ||= Router.new
        @router.instance_eval(&block)
      end
      
      def get_rack_app(env)
        if @router
          @router.find_by_url env['PATH_INFO']
        else
          raise 'No routes!'
        end
      end
    end
  end
end