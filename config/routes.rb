# frozen_string_literal: true

Rails.application.routes.draw do
  defaults format: :json do
    namespace :api do
      namespace :v1 do
        resources :tasks, only: %i[create update] do
          post 'mark_as_completed', on: :member
          post 'mark_as_pending', on: :member
        end

        resources :users, only: %i[create]
      end
    end

    devise_for :users, class_name: 'User::Infrastructure::ActiveRecordModels::User', skip: :all

    devise_scope :user do
      post '/api/v1/auth/sign_in', to: 'api/v1/auth#create'
    end
  end
end
