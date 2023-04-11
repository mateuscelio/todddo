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
        expect do
          described_class.store(user)
        end.to_not change(User::Infrastructure::ActiveRecordUserRepository, :count)
      end

      it 'updates the existing entry' do
        expect { described_class.store(user) }
          .to(change { user_ar.reload.email }.to('email2@mail.com')
          .and(change { user_ar.reload.name }.to("#{user_ar.name}1")))
      end

      context 'with task_ids' do
        let!(:tasks_ar) { create_list(:task, 2) }
        let!(:user) do
          User::Domain::UserEntity.new(id: user_ar.id, name: "#{user_ar.name}1", email: 'email2@mail.com',
                                       password: '123412341234', task_ids: tasks_ar.map(&:id),
                                       updated_at: user_ar.updated_at, created_at: user_ar.created_at)
        end

        it 'ignores task_ids list and does not update task association' do
          described_class.store(user)
          expect(user_ar.reload.tasks.length).to eq(0)
        end
      end
    end
  end

  describe '.find' do
    let(:user_ar) { create(:user) }
    let!(:tasks_ar) { create_list(:task, 2, user: user_ar) }

    it 'returns an instance of user entity' do
      expect(described_class.find(user_ar.id)).to be_an_instance_of User::Domain::UserEntity
    end

    it 'returns entity instance with task_ids' do
      expect(described_class.find(user_ar.id).task_ids).to match_array(tasks_ar.map(&:id))
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
