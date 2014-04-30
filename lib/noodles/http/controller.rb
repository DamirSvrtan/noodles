require 'erubis'
require 'haml'
require 'slim'
module Noodles
  module Http
    class Controller

      attr_reader :env

      def initialize(env)
        @env = env
        @routing_params = {}
      end

      def render(template={})
        if template.has_key? :html
          filename = get_rendering_path template[:html], :html
          File.read(filename)
        elsif template.has_key? :erb
          filename = get_rendering_path template[:erb], :erb
          template = File.read(filename)
          Erubis::Eruby.new(template).result(mapped_instance_variables)
        elsif template.has_key? :haml
          filename = get_rendering_path template[:haml], :haml
          template = File.read(filename)
          Haml::Engine.new(template).render(map_instance_variables_to_object)
        elsif template.has_key? :slim
          filename = get_rendering_path template[:slim], :slim
          Slim::Template.new(filename).render(map_instance_variables_to_object)
        end
      end

      def dispatch(action, routing_params = {})
        @routing_params = routing_params
        text = self.send(action)
        [200, {'Content-Type' => 'text/html'}, [text].flatten]
      end

      def self.action(act, rp = {})
        proc { |e| self.new(e).dispatch(act, rp) }
      end

      def get_rendering_path(view_name, template_type)
        File.join 'app', 'views', controller_name, "#{view_name}.#{template_type}"
      end

      def request
        @request ||= Rack::Request.new(env)
      end

      def params
        request.params.merge @routing_params
      end

      def response(body, status = 200, headers={})
        if @response
          raise "Already Responded"
        else
          @response = Rack::Response.new [body], status, headers
        end
      end

      def get_response
        @response
      end

      def render_response(*args)
        response(render(*args))
      end

      private
        
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