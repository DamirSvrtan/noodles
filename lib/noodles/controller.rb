require 'erubis'

module Noodles
  class Controller

    attr_reader :env

    def initialize(env)
      @env = env
    end

    def render(view_name)
      filename = File.join 'app', 'views', controller_name, "#{view_name}.html.erb"
      template = File.read(filename)
      Erubis::Eruby.new(template).result(mapped_instance_variables)
    end

    def controller_name
      klass = self.class.to_s.gsub /Controller$/, ""
      Noodles.to_underscore klass
    end

    def mapped_instance_variables
      Hash[self.instance_variables.map {|var| [var, self.instance_variable_get(var)]}]
    end

  end
end