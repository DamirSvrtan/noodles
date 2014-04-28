module Noodles
  module Http
    class Router

      attr_reader :routes

      def initialize
        @routes = []
      end
      
      def match(url, destination)
        url_parts = url.split("/")
        url_parts.select! { |p| !p.empty? }
 
        path_params = []
 
        regexp_parts = url_parts.map do |url_part|
          if url_part[0] == ":"
            path_params << url_part[1..-1]
            "([a-zA-Z0-9]+)"
          elsif url_part[0] == "*"
            path_params << url_part[1..-1]
            "(.*)" 
          else
            url_part 
          end
        end
 
        regexp = regexp_parts.join("/")
        
        routes.push url: url, regexp: Regexp.new("^/#{regexp}$"),
                    destination: destination, path_params: path_params
      end
      
      def find_by_url(url)
        routes.each do |route|
          data_match = route[:regexp].match(url)
          if data_match
            path_params = {}
            route[:path_params].each_with_index do |path_param, index|
              path_params[path_param] = data_match.captures[index]
            end
            return get_destination(route[:destination], path_params)
          end   
        end
        nil
      end
 
      def get_destination(destination, path_params = {})
        if destination.respond_to?(:call)
          destination
        else
          controller_name, action = destination.split('#')
          controller_name = controller_name.capitalize
          controller = Object.const_get("#{controller_name}Controller")
          controller.action(action, path_params)
        end
      end
 
    end
  end
end
 
 
module Noodles
  module Http
    class Application
      def route(&block)
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