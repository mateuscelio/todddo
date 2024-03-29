# frozen_string_literal: true

module Task
  module Domain
    class TaskEntity < Entity
      NAME_MAXIMUM_LENGTH = 250
      DESCRIPTION_MAXIMUM_LENGTH = 2500

      attr_accessor :name, :description, :due_at, :completed, :created_at, :updated_at, :id, :user_id

      def self.create(id:, name:, due_at:, user_id:, description: '')
        created_at = Time.current
        updated_at = created_at

        new(id:, name:, due_at:, description:, created_at:, updated_at:, user_id:)
      end

      def initialize(name:, due_at:, id:, user_id:, created_at: nil, updated_at: nil, description: '', completed: false)
        @id = id
        @name = name
        @description = description
        @due_at = due_at
        @completed = completed
        @created_at = created_at
        @updated_at = updated_at
        @validation_errors = []
        @user_id = user_id

        validate!
      end

      def self.update(task, **attributes)
        attributes.merge(updated_at: Time.current)
        task.clone_with(**attributes)
      end

      def self.mark_as_completed(task)
        task.clone_with(completed: true)
      end

      def self.mark_as_pending(task)
        task.clone_with(completed: false)
      end

      private

      attr_accessor :validation_errors

      def validate!
        validate_name!
        validate_description!
        validate_due_at!
        validate_completed!

        raise Errors::InvalidEntity, validation_errors unless validation_errors.empty?
      end

      def validate_name!
        validation_errors << 'Name cannot be empty' if name && name.empty?
        validation_errors << 'Name too long' if name.length > NAME_MAXIMUM_LENGTH

        true
      end

      def validate_description!
        validation_errors << 'Description too long' if description.length > DESCRIPTION_MAXIMUM_LENGTH

        true
      end

      def validate_due_at!
        validation_errors << 'Due at cannot be in the past' if due_at && due_at < Time.zone.now

        true
      end

      def validate_completed!
        validation_errors << 'Due at cannot be in the past' unless [true, false].include? completed

        true
      end
    end
  end
end
