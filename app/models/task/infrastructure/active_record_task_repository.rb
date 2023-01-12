# frozen_string_literal: true

module Task
  module Infrastructure
    class ActiveRecordTaskRepository < Domain::TaskRepository
      def self.store(task)
        ActiveRecordModels::Task.upsert(task.to_h)
      end

      def self.find(task_id)
        task = ActiveRecordModels::Task.find(task_id)

        Domain::TaskEntity.new(**task.attributes.symbolize_keys)
      end

      def self.count
        ActiveRecordModels::Task.count
      end

      def self.next_id
        # This is not the recommended way to generate new Ids
        # since it is not resistant to concurrency
        (ActiveRecordModels::Task.last&.id || 0) + 1
      end

      def self.last
        task = ActiveRecordModels::Task.last

        Domain::TaskEntity.new(**task.attributes.symbolize_keys)
      end
    end
  end
end
