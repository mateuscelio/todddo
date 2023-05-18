# frozen_string_literal: true

module Task
  module Domain
    class ValidateOwnership
      def self.validate!(task:, user:)
        raise Errors::Unauthorized, "User doesn't own this task" if task.user_id != user.id
      end
    end
  end
end
