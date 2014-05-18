require "noodles/http/router"
require "noodles/http/controller"
require "noodles/http/errors/no_router_error"

module Noodles
  module Http
    class Application

      def call(env)
        if rack_app = get_rack_app(env)
          rack_app.call(env)
        else
          response_not_found
        end
      end

      def routes(&block)
        @router ||= Router.new
        @router.instance_eval(&block)
      end

      private

        def get_rack_app(env)
          raise NoRouterError.new if @router.nil?
          @router.find_by_url(env['REQUEST_METHOD'], env['PATH_INFO'])
        end

        def response_not_found  
          [404, {'Content-Type' => 'text/html'}, ["<h1>404</h1>"]]
        end
    end
  end
end