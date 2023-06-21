# frozen_string_literal: true

module User
  module Infrastructure
    class ActiveRecordUserRepository < Domain::UserRepository
      def self.store(user)
        user_hash = user.to_h

        # Avoid unintentionally password update to nil
        user_hash = user_hash.slice!(:password) if user_hash[:password].nil?
        # Does not update relation with task through User
        user_hash = user_hash.slice!(:task_ids)

        # This is required because for devise hooks work properly. Ex: hash the password
        current_user = ActiveRecordModels::User.find_by(id: user_hash[:id])
        if current_user.nil?
          ActiveRecordModels::User.create!(user_hash)
        else
          current_user.update!(user_hash)
        end
      end

      def self.find(user_id)
        user = ActiveRecordModels::User.find(user_id)

        ActiveRecordUserMapper.to_entity(user:)
      end

      def self.find_by_email(user_email)
        user = ActiveRecordModels::User.find_by(email: user_email)

        return if user.nil?

        ActiveRecordUserMapper.to_entity(user:)
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
        ActiveRecordUserMapper.to_entity(user:)
      end
    end
  end
end
