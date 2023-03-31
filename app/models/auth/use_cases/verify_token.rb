# frozen_string_literal: true

module Auth
  module UseCases
    class VerifyToken
      class InvalidTokenError < StandardError; end
      SECRET_KEY = Rails.application.secrets.secret_key_base

      def initialize(token:, user_repository:)
        @token = token
        @user_repository = user_repository
      end

      def call
        decoded_token = JWT.decode(token, SECRET_KEY)
        user_id = decoded_token[0]['id']
        user_repository.find(user_id)
      rescue JWT::DecodeError => e
        raise InvalidTokenError, e.message
      end

      private

      attr_reader :token, :user_repository
    end
  end
end
