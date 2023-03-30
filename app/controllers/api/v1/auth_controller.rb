# frozen_string_literal: true

module Api
  module V1
    class AuthController < Devise::SessionsController
      # before_action :configure_sign_in_params, only: [:create]

      # GET /resource/sign_in
      # def new
      #   super
      # end

      # POST /resource/sign_in
      def create
        super do |user|
          token = ::Auth::UseCases::CreateToken
                  .new(user_repository: ::User::Infrastructure::ActiveRecordUserRepository)
                  .call(user_id: user.id)

          return render json: { token: }
        end
      end

      # DELETE /resource/sign_out
      # def destroy
      #   super
      # end

      # protected

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_in_params
      #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
      # end
    end
  end
end
