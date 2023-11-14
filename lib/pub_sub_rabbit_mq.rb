class PubSubRabbitMq
  include Singleton

  def initialize
    @subscribers = {}
  end

  def subscribe(topic, handler)
    subscriber_topic = @subscribers[topic]
    if subscriber_topic.nil?
      @subscribers[topic] = [handler]
    else
      @subscribers[topic] << handler
    end
  end

  def publish(topic:, message:)
    RabbitMq::Client::Connection.instance.channel.with do |channel|
      channel.queue('in_app_communication', durable: true).publish(
        { topic:, message: }.to_json,
        routing_key: 'in_app_communication'
      )
    end
  end

  def call_handler(topic:, message:)
    subscribed_topics = subscribers[topic]
    return if subscribed_topics.blank?

    subscribed_topics.each do |topic|
      topic.call(message)
    end
  end

  private

  attr_reader :subscribers
end
