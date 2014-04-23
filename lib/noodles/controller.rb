require 'erubis'

module Noodles
  class Controller

    attr_reader :env

    def initialize(env)
      @env = env
    end

    def render(view_name, locals={})
      filename = File.join 'app', 'views', "#{view_name}.html.erb"
      template = File.read(filename)
      Erubis::Eruby.new(template).result(locals.merge(env: env))
    end
  end
end