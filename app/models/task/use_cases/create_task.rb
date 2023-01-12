# frozen_string_literal: true

module Task
  module UseCases
    class CreateTask
      def initialize(name:, due_at:, task_repository:, description: '')
        @name = name
        @due_at = due_at
        @description = description
        @task_repository = task_repository
      end

      def call
        id = task_repository.next_id

        task = Domain::TaskEntity.create(id:, name:, due_at:, description:)

        task_repository.store(task)

        task
      end

      private

      attr_accessor :due_at, :name, :description, :task_repository
    end
  end
end
