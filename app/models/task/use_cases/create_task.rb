# frozen_string_literal: true

module Task
  module UseCases
    class CreateTask
      def initialize(name:, due_at:, user_id:, task_repository:, description: '')
        @name = name
        @due_at = due_at
        @description = description
        @task_repository = task_repository
        @user_id = user_id
      end

      def call
        id = task_repository.next_id

        task = Domain::TaskEntity.create(id:, name:, user_id:, due_at:, description:)

        task_repository.store(task)

        task
      end

      private

      attr_accessor :due_at, :name, :description, :task_repository, :user_id
    end
  end
end
