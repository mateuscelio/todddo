# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /api/v1/users' do
    let(:user_repository) { User::Infrastructure::ActiveRecordUserRepository }
    subject(:post_create_user) { post '/api/v1/users', params: }

    context 'when params are valid' do
      let(:params) { { user: { name: 'user', email: 'user@email.com', password: 'password' } } }

      it 'is successful' do
        post_create_user
        expect(response).to have_http_status(:success)
      end

      it 'creates new user' do
        expect { post_create_user }.to change(user_repository, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let(:params) { { user: { name: 'user', email:, password: 'password' } } }

      context 'with an email already in use' do
        let(:email) { 'user@email.com' }

        before do
          user = User::Domain::UserEntity.create(id: user_repository.next_id, email:, name: 'user',
                                                 password: 'Password123')
          user_repository.store(user)
        end

        it 'returns error' do
          expect { subject }.to_not change(user_repository, :count)
          expect(json_response).to eq(
            {
              error: {
                details: 'E-mail already in use!',
                message: 'Validation error',
                type: 'ValidationError'
              }
            }
          )
        end
      end
    end
  end
end
