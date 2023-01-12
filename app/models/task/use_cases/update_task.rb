# frozen_string_literal: true

module Task
  module UseCases
    class UpdateTask
      def initialize(id:, attributes:, task_repository:)
        @id = id
        @attributes = attributes.slice(:name, :due_at, :description, :completed)
        @task_repository = task_repository
      end

      def call
        task = task_repository.find(id)

        updated_task = Domain::TaskEntity.update(task, **attributes)

        task_repository.store(updated_task)

        TaskMailer.task_updated(updated_task.id, ['dev@mail.com']).deliver_later

        updated_task
      end

      private

      attr_reader :id, :attributes, :task_repository
    end
  end
end
