module Noodles
  module Http
    class Router
      attr_reader :routes

      def initialize
        @routes = []
      end
      
      [:get, :post, :put, :delete].each do |method|
        define_method method do |url, destination|
          match(method, url, destination)
        end
      end

      def root_to(destination)
        get('', destination)
      end

      def find_by_url(method, url)
        method = method.downcase.to_sym

        route = routes.find do |route|
          route[:method] == method and route[:regexp].match(url)
        end

        return if route.nil?

        data_match = route[:regexp].match(url)

        path_params = {}
        route[:path_params].each_with_index do |path_param, index|
          path_params[path_param] = data_match.captures[index]
        end
        get_destination(route[:destination], path_params)
      end

      private

        def match(method, url, destination)
          regexp, path_params = regexed_url_and_path_params(url)
          
          routes.push method: method, url: url, regexp: Regexp.new("^/#{regexp}$"),
                      destination: destination, path_params: path_params
        end


        def regexed_url_and_path_params(url)
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
          [regexp, path_params]
        end

        def get_destination(destination, path_params = {})
          return destination if destination.respond_to?(:call)

          controller_name, action = destination.split('#')
          controller_name = controller_name.capitalize
          controller = Object.const_get("#{controller_name}Controller")
          controller.action(action, path_params)
        end
 
    end
  end
end