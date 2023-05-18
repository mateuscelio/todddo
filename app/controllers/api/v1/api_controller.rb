# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      rescue_from Errors::InvalidEntity, with: :record_invalid
      rescue_from Auth::UseCases::VerifyToken::InvalidTokenError, with: :invalid_token
      rescue_from Errors::Unauthorized, with: :unauthorized

      private

      def authenticate_user!
        header = request.headers['Authorization']
        token = header.split.last if header
        @user = Auth::UseCases::VerifyToken
                .new(user_repository: User::Infrastructure::ActiveRecordUserRepository)
                .call(token:)
      end

      def invalid_token(_exception)
        error = {
          type: 'InvalidTokenError',
          message: 'Unauthorized'
        }

        render json: ErrorSerializer.new(error).serializable_hash, status: :unauthorized
      end

      def record_invalid(exception)
        error = {
          type: 'ValidationError',
          message: 'Validation error',
          details: exception.errors
        }
        render json: ErrorSerializer.new(error).serializable_hash, status: :unprocessable_entity
      end

      def unauthorized(exception)
        error = {
          type: 'Unauthorized',
          message: exception.message
        }

        render json: ErrorSerializer.new(error).serializable_hash, status: :unauthorized
      end
    end
  end
end
