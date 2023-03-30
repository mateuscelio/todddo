# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  describe 'POST /api/v1/auth' do
    subject(:post_sign_in) { post '/api/v1/auth/sign_in', params: }
    let(:user_ar) { create(:user) }

    context 'when params are valid' do
      let(:params) { { user: { email: user_ar.email, password: user_ar.password } } }

      it 'is successful' do
        post_sign_in
        expect(response).to have_http_status(:success)
      end

      it 'returns an access token' do
        post_sign_in
        expect(response.body).to include('token')
      end
    end

    context 'when params are invalid' do
      let(:params) { { user: { email:, password: } } }

      shared_examples 'unauthorized response' do
        it 'returns unauthorized status' do
          post_sign_in

          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns error message' do
          post_sign_in

          expect(response.body).to eq('{"error":"Invalid Email or password."}')
        end
      end

      context 'when email is invalid' do
        let(:email) { 'invalid@email.com' }
        let(:password) { 'invalid password' }

        it_behaves_like 'unauthorized response'
      end

      context 'when email is valid but password is not' do
        let(:email) { user_ar.email }
        let(:password) { 'invalid password' }

        it_behaves_like 'unauthorized response'
      end
    end
  end
end
