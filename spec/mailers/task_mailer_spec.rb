# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskMailer, type: :mailer do
  describe '#task_updated' do
    let(:task) { create(:task) }
    let(:emails) { ['test@mail.com', 'test2@mail.com'] }

    subject(:mail) { described_class.task_updated(task.id, emails) }

    it 'sends to specified emails' do
      expect(mail.to).to match_array emails
    end

    it 'renders subject' do
      expect(mail.subject).to eq "Task #{task.id} was updated!"
    end

    it 'renders task details in the body' do
      expect(mail.body.encoded).to match task.name.to_s
      expect(mail.body.encoded).to match task.description.to_s
      expect(mail.body.encoded).to match task.due_at.to_s
    end
  end
end
