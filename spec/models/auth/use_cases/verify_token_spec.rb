# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::UseCases::VerifyToken, type: :class do
  include ActiveSupport::Testing::TimeHelpers

  describe '.call' do
    let(:user_ar) { create(:user) }
    let(:user_repository) { User::Infrastructure::ActiveRecordUserRepository }
    let(:token) { Auth::UseCases::CreateToken.new(user_id: user_ar.id, user_repository:).call }

    subject(:service) { described_class.new(token:, user_repository:) }

    it 'returns the user for the given token' do
      expect(service.call.to_h).to eq(user_repository.find(user_ar.id).to_h)
    end

    context 'with an expired token' do
      let!(:token) { Auth::UseCases::CreateToken.new(user_id: user_ar.id, user_repository:).call }

      it 'raises an error' do
        travel_to 8.days.from_now do
          expect do
            service.call
          end.to raise_error(Auth::UseCases::VerifyToken::InvalidTokenError, 'Signature has expired')
        end
      end
    end

    context 'with invalid token' do
      let(:token) { '' }

      it 'raises error' do
        expect do
          service.call
        end.to raise_error(Auth::UseCases::VerifyToken::InvalidTokenError, 'Not enough or too many segments')
      end
    end
  end
end
