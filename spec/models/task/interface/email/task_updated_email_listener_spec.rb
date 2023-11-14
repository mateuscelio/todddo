# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task::Interface::Email::TaskUpdatedEmailListener, type: :class do
  let(:pub_sub) { PubSubRabbitMq.instance }

  subject { described_class.new(pub_sub:) }

  describe '.call' do
    context 'when subscribed and an event is sent' do
      let(:task) { create(:task) }
      let(:mailer) { double(deliver_later: true) }

      it 'handles the event sending an email' do
        allow(TaskMailer).to receive(:task_updated).with(task.id, ['dev@mail.com']).and_return(mailer)

        subject.call
        Task::UseCases::CreateTaskUpdatedEvent.new(task_id: task.id, pub_sub:).call

        expect(mailer).to have_received(:deliver_later)
      end
    end
  end
end
