# frozen_string_literal: true

module User
  module Infrastructure
    class ActiveRecordUserRepository < Domain::UserRepository
      def self.store(user)
        ActiveRecordModels::User.upsert(user.to_h)
      end

      def self.find(user_id)
        user = ActiveRecordModels::User.find(user_id)

        Domain::UserEntity.new(id: user.id, email: user.email, name: user.name, created_at: user.created_at,
                               updated_at: user.updated_at)
      end

      def self.count
        ActiveRecordModels::User.count
      end

      def self.next_id
        # This is not the recommended way to generate new Ids
        # since it is not resistant to concurrency
        (ActiveRecordModels::User.last&.id || 0) + 1
      end

      def self.last
        user = ActiveRecordModels::User.last

        Domain::UserEntity.new(**user.attributes.symbolize_keys)
      end
    end
  end
end
