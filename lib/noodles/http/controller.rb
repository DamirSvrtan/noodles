require 'erubis'
require 'haml'
require 'slim'
module Noodles
  module Http
    class Controller

      attr_reader :env, :request, :response

      def initialize(env)
        @env = env
        @routing_params = {}
        @request = Rack::Request.new(env)
        @response = Rack::Response.new([], 200, {'Content-Type' => 'text/html'})
      end

      def text(textual_response)
        @response['Content-Type'] = 'text/plain'
        @response.body = [textual_response]
      end

      def html(template_name)
        filename = get_rendering_path template_name, :html
        @response.body = [File.read(filename)]
      end

      def erb(template_name)
        filename = get_rendering_path template_name, :erb
        template = File.read(filename)
        @response.body = [Erubis::Eruby.new(template).result(mapped_instance_variables)]
      end

      def haml(template_name)
        filename = get_rendering_path template_name, :haml
        template = File.read(filename)
        @response.body = [Haml::Engine.new(template).render(map_instance_variables_to_object)]
      end

      def slim(template_name)
        filename = get_rendering_path template_name, :slim
        @response.body = [Slim::Template.new(filename).render(map_instance_variables_to_object)]
      end

      def params
        request.params.merge @routing_params
      end

      def self.action(action, routing_params)
        proc { |e| self.new(e).dispatch(action, routing_params) }
      end

      def dispatch(action, routing_params)
        @routing_params = routing_params
        self.send(action)
        @response.finish
      end

      private

        def get_rendering_path(view_name, template_type)
          File.join 'app', 'views', controller_name, "#{view_name}.#{template_type}"
        end

        def controller_name
          klass = self.class.to_s.gsub /Controller$/, ""
          Noodles.to_underscore klass
        end

        def mapped_instance_variables
          Hash[self.instance_variables.map {|var| [var, self.instance_variable_get(var)]}]
        end

        def map_instance_variables_to_object
          new_object = Object.new
          mapped_instance_variables.each do |k,v|
            new_object.instance_variable_set k, v
          end
          new_object
        end
    end
  end
end