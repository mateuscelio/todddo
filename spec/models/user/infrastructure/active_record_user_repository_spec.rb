# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Infrastructure::ActiveRecordUserRepository, type: :class do
  describe '.store' do
    context 'with a user that does not exist yet' do
      it 'creates a new entry' do
        user = User::Domain::UserEntity.create(id: 3, name: 'User', email: 'random@email.com', password: '12341234')

        expect { described_class.store(user) }.to change(described_class, :count).from(0).to(1)
      end
    end

    context 'with a user that already exist' do
      let(:user_ar) { create(:user, name: 'Username') }
      let!(:user) do
        User::Domain::UserEntity.create(id: user_ar.id, name: "#{user_ar.name}1", email: 'email2@mail.com',
                                        password: '123412341234')
      end

      it 'does not create new entry' do
        expect { described_class.store(user) }.to_not change(User::Infrastructure::ActiveRecordUserRepository, :count)
      end

      it 'updates the existing entry' do
        expect { described_class.store(user) }
          .to(change { user_ar.reload.email }.to('email2@mail.com')
          .and(change { user_ar.reload.name }.to("#{user_ar.name}1")))
      end
    end
  end

  describe '.find' do
    let(:user_id) { create(:user).id }

    it 'returns an instance of user entity' do
      expect(described_class.find(user_id)).to be_an_instance_of User::Domain::UserEntity
    end
  end

  describe '.count' do
    before { create(:user) }

    it 'returns stored entities count' do
      expect(described_class.count).to eq 1
    end
  end

  describe '.next_id' do
    context 'without entry' do
      it 'returns id 1' do
        expect(described_class.next_id).to eq(1)
      end
    end

    context 'with  entry' do
      before { create(:user, id: 3) }
      it 'returns next id related to the last entry id ' do
        expect(described_class.next_id).to eq(4)
      end
    end
  end
end
