class PubSub
  @instance = new
  @subscribers = {}

  private_class_method :new

  class << self
    def subscribe(topic, handler)
      subscriber_topic = @subscribers[topic]
      if subscriber_topic.nil?
        @subscribers[topic] = [handler]
      else
        @subscribers[topic] << handler
      end
    end

    def publish(topic:, message:)
      subscriber_topic = subscribers[topic]

      return if subscriber_topic.nil?

      subscriber_topic.each do |handler|
        handler.call(message)
      end
    end

    private

    attr_reader :subscribers
  end
end
