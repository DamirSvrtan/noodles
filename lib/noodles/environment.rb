module Noodles
  module Environment
    class << self

      def development?
        environment.to_s == 'development'
      end

      def production?
        environment.to_s == 'production'
      end

      def test?
        environment.to_s == 'test'
      end

      def environment?
        environment
      end

      def ==(other)
        case other
        when String
          environment.to_s == other
        when Symbol
          environment.to_sym == other
        else
          super
        end
      end

      private

        def environment
          ENV['RACK_ENV'] || 'development'
        end
    end
  end
end