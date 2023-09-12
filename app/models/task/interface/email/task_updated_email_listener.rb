module Task
  module Interface
    module Email
      class TaskUpdatedEmailListener
        def initialize(pub_sub:)
          @pub_sub = pub_sub
        end

        def call
          pub_sub.subscribe('task_updated_event', handler)
        end

        private

        attr_reader :pub_sub

        def handler
          lambda { |task_id|
            TaskMailer.task_updated(task_id, ['dev@mail.com']).deliver_later
          }
        end
      end
    end
  end
end
