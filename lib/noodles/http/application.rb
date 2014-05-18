require "noodles/http/router"
require "noodles/http/controller"

module Noodles
  module Http
    class Application
      def call(env)
        if rack_app = get_rack_app(env)
          rack_app.call(env)
        else
          return bad_request(true)
        end
      end

      def routes(&block)
        @router ||= Router.new
        @router.instance_eval(&block)
      end

      private

        def get_rack_app(env)
          if @router
            @router.find_by_url(env['REQUEST_METHOD'], env['PATH_INFO'])
          else
            raise 'No routes!'
          end
        end

        def bad_request(include_body=false)
          body = if include_body
            "<h1>404</h1>"
          end
          [400, {'Content-Type' => 'text/html'}, [body]]
        end
    end
  end
end