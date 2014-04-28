module Noodles
  module Http
    class Router
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
        
        @routes.push regexp: Regexp.new("^/#{regexp}$"),
                     path_params: path_params, 
                     destination: destination, 
                     url: url
      end
      
      def check_url(url)
        @routes.each do |r|
          data_match = r[:regexp].match(url)
          if data_match
            params = {}
            r[:path_params].each_with_index do |path_param, index|
              params[path_param] = data_match.captures[index]
            end
            return get_destination(r[:destination], params)
          end   
        end
        nil
      end
 
      def get_destination(destination, routing_params = {})
        return destination if destination.respond_to?(:call)
        if destination =~ /^([^#]+)#([^#]+)$/
          name = $1.capitalize
          cont = Object.const_get("#{name}Controller")
          return cont.action($2, routing_params)
        end
        raise "No destination: #{destination.inspect}!"
      end
 
    end
  end
end
 
 
module Noodles
  module Http
    class Application
      def route(&block)
        @route_obj ||= Router.new
        @route_obj.instance_eval(&block)
      end
      
      def get_rack_app(env)
        raise 'No routes!' unless @route_obj
        @route_obj.check_url env['PATH_INFO']
      end
      # def get_controller_and_action(env)
      #   _, controller, action, after = env['PATH_INFO'].split('/', 4)
      #   controller = controller.capitalize
      #   controller += 'Controller'
      #   [Object.const_get(controller), action]
      # end
    end
  end
end