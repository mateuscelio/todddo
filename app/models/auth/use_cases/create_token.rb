module Auth
  module UseCases
    class CreateToken
      TOKEN_EXPIRATION_SECONDS = 60 * 60 * 24 * 7
      SECRET_KEY = Rails.application.secrets.secret_key_base

      def initialize(user_repository:)
        @user_repository = user_repository
      end

      def call(user_id:)
        user = user_repository.find(user_id)
        JWT.encode(create_payload(user), SECRET_KEY)
      end

      private

      attr_reader :user_repository

      def create_payload(user)
        {
          id: user.id,
          email: user.email,
          exp: Time.current.to_i + TOKEN_EXPIRATION_SECONDS
        }
      end
    end
  end
end
