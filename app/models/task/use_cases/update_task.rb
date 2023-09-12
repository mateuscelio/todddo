# frozen_string_literal: true

module Task
  module UseCases
    class UpdateTask
      def initialize(id:, attributes:, task_repository:, updated_by:, validate_ownership:, pub_sub:)
        @id = id
        @attributes = attributes.slice(:name, :due_at, :description, :completed)
        @task_repository = task_repository
        @updated_by = updated_by
        @validate_ownership = validate_ownership
        @pub_sub = pub_sub
      end

      def call
        task = task_repository.find(id)

        validate_ownership.validate!(task:, user: updated_by)

        updated_task = Domain::TaskEntity.update(task, **attributes)

        task_repository.store(updated_task)

        CreateTaskUpdatedEvent.new(task_id: updated_task.id, pub_sub:).call

        updated_task
      end

      private

      attr_reader :id, :attributes, :task_repository, :updated_by, :validate_ownership, :pub_sub
    end
  end
end
