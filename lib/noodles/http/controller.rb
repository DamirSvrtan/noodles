require 'noodles/http/view'
require 'tilt/erubis'
require 'tilt/haml'
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
        @response.body = [read_file(template_name, :html)]
      end

      def json(jsonized_response)
        @response['Content-Type'] = 'application/json'
        unless jsonized_response.is_a? String
          jsonized_response = jsonized_response.to_json
        end
        @response.body = [jsonized_response]
      end

      [:erb, :haml, :slim].each do |template_engine|
        define_method template_engine do |template_name|
          filename = get_rendering_path(template_name, template_engine)
          @response.body = [Tilt.new(filename).render(map_instance_variables_to_object)]
        end
      end

      def params
        request.params.merge @routing_params
      end

      def redirect(redirect_path, status=302)
        @response.body = []
        @response['Location'] = redirect_path
        @response.status = status
      end

      alias_method :redirect_to, :redirect

      def self.action(action, routing_params)
        proc { |e| self.new(e).dispatch(action, routing_params) }
      end

      def dispatch(action, routing_params)
        @routing_params = routing_params
        self.send(action)
        @response.finish
      end

      def self.view(view)
        @@view = view
      end

      def view_clazz
        if defined? @@view
          @@view
        else
          View
        end
      end

      private

        def read_file(template_name, template_type)
          File.read get_rendering_path(template_name, template_type)
        end

        def get_rendering_path(template_name, template_type)
          File.join 'app', 'templates', controller_name, "#{template_name}.#{template_type}"
        end

        def controller_name
          klass = self.class.to_s.gsub /Controller$/, ""
          Noodles.to_underscore klass
        end

        def mapped_instance_variables
          Hash[self.instance_variables.map {|var| [var, self.instance_variable_get(var)]}]
        end

        def map_instance_variables_to_object
          new_object = view_clazz.new
          mapped_instance_variables.each do |k,v|
            new_object.instance_variable_set k, v
          end
          new_object
        end
    end
  end
end