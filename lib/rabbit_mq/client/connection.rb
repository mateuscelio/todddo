module RabbitMq
  module Client
    class Connection
      include Singleton

      def initialize
        @connection ||= Bunny.new(hostname: 'localhost', automatically_recover: false)
        @connection.start
      end

      def channel
        @channel ||= ConnectionPool.new do
          connection.create_channel
        end
      end

      private

      attr_reader :connection
    end
  end
end
