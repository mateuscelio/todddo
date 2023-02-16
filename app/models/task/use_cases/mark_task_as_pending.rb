# frozen_string_literal: true

module Task
  module UseCases
    class MarkTaskAsPending
      def initialize(id:, task_repository:)
        @id = id
        @task_repository = task_repository
      end

      def call
        task = task_repository.find(id)
        pending_task = Domain::TaskEntity.mark_as_pending(task)
        task_repository.store(pending_task)
      end

      private

      attr_reader :id, :task_repository
    end
  end
end
