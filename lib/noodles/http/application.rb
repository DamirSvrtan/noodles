require "noodles/http/router"
require "noodles/http/controller"

module Noodles
  module Http
    class Application
      def call(env)
        if env['PATH_INFO'] == '/favicon.ico'
          return bad_request
        end

        if rack_app = get_rack_app(env)
          rack_app.call(env)
        else
          return bad_request
        end
      end

      def routes(&block)
        @router ||= Router.new
        @router.instance_eval(&block)
      end

      private

        def get_rack_app(env)
          if @router
            @router.find_by_url env['PATH_INFO']
          else
            raise 'No routes!'
          end
        end

        def bad_request
          [400, {'Content-Type' => 'text/html'}, []]
        end
    end
  end
end