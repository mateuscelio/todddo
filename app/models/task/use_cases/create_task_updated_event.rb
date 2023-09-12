module Task
  module UseCases
    class CreateTaskUpdatedEvent
      def initialize(task_id:, pub_sub:)
        @task_id = task_id
        @pub_sub = pub_sub
      end

      def call
        pub_sub.publish(topic: 'task_updated_event', message: task_id)
      end

      private

      attr_accessor :pub_sub, :task_id
    end
  end
end
