# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auth::UseCases::CreateToken, type: :class do
  include ActiveSupport::Testing::TimeHelpers

  describe '.call' do
    let(:user_repository) { User::Infrastructure::ActiveRecordUserRepository }
    let(:user) do
      User::UseCases::CreateUser.new(user_repository:).call(name: 'User', email: 'random@email.com',
                                                            password: '12341234')
    end

    subject(:service) { described_class.new(user_repository:) }
    it "creates the token with user's id and email" do
      token = service.call(user_id: user.id)
      expect(JWT.decode(token, nil, false)[0]).to include('id' => user.id, 'email' => user.email)
    end

    it 'token expires in 7 days' do
      freeze_time do
        token = service.call(user_id: user.id)
        expect(JWT.decode(token, nil, false)[0]).to include('exp' => 7.days.from_now.to_i)
      end
    end
  end
end
