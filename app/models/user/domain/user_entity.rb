# frozen_string_literal: true

module User
  module Domain
    class UserEntity < Entity
      attr_accessor :id, :email, :name, :created_at, :updated_at, :password, :notification_settings
      attr_reader :task_ids

      def self.create(id:, email:, name:, password:)
        created_at = Time.current
        updated_at = created_at

        new(id:, email:, name:, password:, created_at:, updated_at:)
      end

      def initialize(id:, email:, name:, created_at:, updated_at:, password: nil, task_ids: [],
                     notification_settings: { 'created_task' => true, 'completed_task' => true })
        @id = id
        @email = email
        @name = name
        @created_at = created_at
        @updated_at = updated_at
        @password = password
        @task_ids = task_ids
        @notification_settings = notification_settings
      end

      def self.update(user, **attributes)
        attributes.merge!(
          task_ids: user.task_ids,
          notification_settings: user.notification_settings,
          updated_at: Time.current
        )

        user.clone_with(**attributes)
      end

      def self.update_notification_settings(user, created_task: nil, completed_task: nil)
        notification_settings = user.notification_settings

        notification_settings['created_task'] = created_task unless created_task.nil?
        notification_settings['completed_task'] = completed_task unless completed_task.nil?

        user.clone_with(updated_at: Time.current, notification_settings:)
      end
    end
  end
end
