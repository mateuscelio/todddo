# frozen_string_literal: true

module User
  module Infrastructure
    class ActiveRecordUserMapper < Domain::UserRepository
      def self.to_entity(user:)
        Domain::UserEntity.new(id: user.id, email: user.email, name: user.name, created_at: user.created_at,
                               updated_at: user.updated_at, task_ids: user.tasks.pluck(:id))
      end
    end
  end
end
