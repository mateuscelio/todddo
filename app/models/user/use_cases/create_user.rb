# frozen_string_literal: true

module User
  module UseCases
    class CreateUser
      def initialize(user_repository:)
        @name = name
        @email = email
        @user_repository = user_repository
      end

      def call(email:, name:)
        id = user_repository.next_id

        user = Domain::UserEntity.create(id:, name:, email:)

        user_repository.store(user)

        user
      end

      private

      attr_accessor :email, :name, :user_repository
    end
  end
end
