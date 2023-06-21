# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Domain::UserEntity, type: :class do
  let(:id) { 1 }
  let(:name) { 'Name' }
  let(:email) { 'test@email.com' }
  let(:password) { '12345678' }
  let(:create_attrs) do
    {
      id:,
      name:,
      email:,
      password:
    }
  end

  let(:user) { described_class.create(**create_attrs) }

  describe '.update' do
    it "doesn't update task_ids and notification_settings" do
      updated_user = described_class.update(user, task_ids: [1, 2, 3, 4], notification_settings: {})

      aggregate_failures do
        expect(updated_user.task_ids).to eq(user.task_ids)
        expect(updated_user.notification_settings).to eq(user.notification_settings)
        expect(updated_user.updated_at).to be > user.updated_at
      end
    end
  end

  describe '.update_notification_settings' do
    it 'updates notification settings' do
      updated_user = described_class.update_notification_settings(user, completed_task: false, created_task: false)

      aggregate_failures do
        expect(updated_user.notification_settings).to eq({ 'completed_task' => false, 'created_task' => false })
        expect(updated_user.updated_at).to be > user.updated_at
      end
    end

    it 'updates only created_task option' do
      updated_user = described_class.update_notification_settings(user, created_task: false)

      expect(updated_user.notification_settings).to eq({ 'completed_task' => true, 'created_task' => false })
    end
  end
end
