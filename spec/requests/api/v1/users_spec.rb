# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /api/v1/users' do
    subject(:post_create_user) { post '/api/v1/users', params: }

    context 'when params are valid' do
      let(:params) { { user: { name: 'user', email: 'user@email.com', password: 'password' } } }

      it 'is successful' do
        post_create_user
        expect(response).to have_http_status(:success)
      end

      it 'creates new user' do
        expect { post_create_user }.to change(User::Infrastructure::ActiveRecordUserRepository, :count).by(1)
      end
    end
  end
end
