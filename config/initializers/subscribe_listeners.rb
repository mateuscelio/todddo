# frozen_string_literal: true

Rails.application.config.after_initialize do
  # We don't want to subscribe to the listeners when in test environment
  # because we will control when to subscribe them during test
  unless Rails.env.test?
    connection = Bunny.new(hostname: 'localhost')
    connection.start
    connection
      .channel
      .queue('in_app_communication', durable: true)
      .subscribe(manual_ack: false) do |_, _, payload|
      parsed_message = JSON.parse(payload, symbolize_names: true)

      PubSubRabbitMq.instance.call_handler(**parsed_message)
    end

    [
      Task::Interface::Email::TaskUpdatedEmailListener
    ].each { |listener| listener.send(:new, pub_sub: PubSub).call }
  end
end
