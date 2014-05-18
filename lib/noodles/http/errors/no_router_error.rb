module Noodles
  module Http
    class NoRouterError < StandardError
      def initialize
        super("No HTTP Routes defined!")
      end
    end
  end
end