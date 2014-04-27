module Noodles
  module Websocket
    class Channel
      # class << self
      #   attr_accessor :connections
      # end
      # self.connections = []

      def self.connections
        @@connections ||= []
      end

      def self.broadcast(msg)
        connections.each do |connection|
          connection.send msg
        end
      end


    end
  end
end