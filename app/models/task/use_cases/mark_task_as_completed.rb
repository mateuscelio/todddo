# frozen_string_literal: true

module Task
  module UseCases
    class MarkTaskAsCompleted
      def initialize(id:, task_repository:)
        @id = id
        @task_repository = task_repository
      end

      def call
        task = task_repository.find(id)
        completed_task = Domain::TaskEntity.mark_as_completed(task)
        task_repository.store(completed_task)
      end

      private

      attr_reader :id, :task_repository
    end
  end
end
