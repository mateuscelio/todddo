# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      def create
        created_user = ::User::UseCases::CreateUser
                       .new(user_repository: User::Infrastructure::ActiveRecordUserRepository)
                       .call(**user_params)

        render json: { id: created_user.id }
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password).to_h.symbolize_keys
      end
    end
  end
end
