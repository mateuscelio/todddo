# frozen_string_literal: true

Rails.application.config.after_initialize do
  # We don't want to subscribe to the listeners when in test environment
  # because we will control when to subscribe them during test
  unless Rails.env.test?

    [
      Task::Interface::Email::TaskUpdatedEmailListener
    ].each { |listener| listener.send(:new, pub_sub: PubSub).call }
  end
end
