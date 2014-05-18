module Noodles
  class NoRouterError < StandardError
    def initialize
      super("No HTTP Routes defined!")
    end
  end
end