# frozen_string_literal: true

module User
  module Domain
    class UserEntity < Entity
      attr_accessor :id, :email, :name, :created_at, :updated_at, :password
      attr_reader :task_ids

      def self.create(id:, email:, name:, password:)
        created_at = Time.current
        updated_at = created_at

        new(id:, email:, name:, password:, created_at:, updated_at:)
      end

      def initialize(id:, email:, name:, created_at:, updated_at:, password: nil, task_ids: [])
        @id = id
        @email = email
        @name = name
        @created_at = created_at
        @updated_at = updated_at
        @password = password
        @task_ids = task_ids
      end

      def self.update(user, **attributes)
        attributes.merge(updated_at: Time.current)
        attributes.merge(task_ids: user.task_ids)
        user.clone_with(**attributes)
      end
    end
  end
end
