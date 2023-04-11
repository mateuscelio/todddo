# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task::Infrastructure::ActiveRecordTaskRepository, type: :class do
  let(:user_id) { create(:user).id }

  describe '.store' do
    context 'with a task that does not exist yet' do
      it 'creates a new entry' do
        task = Task::Domain::TaskEntity.create(id: 3, user_id:, name: 'Task 1', due_at: 1.day.from_now)

        expect { described_class.store(task) }.to change(described_class, :count).from(0).to(1)
      end
    end

    context 'with a task that already exist' do
      let(:task_ar) { create(:task) }
      let!(:task) do
        Task::Domain::TaskEntity.create(id: task_ar.id, user_id: task_ar.user_id, name: 'Task 1',
                                        due_at: 1.day.from_now)
      end

      it 'does not create new entry' do
        expect { described_class.store(task) }.to_not change(Task::Infrastructure::ActiveRecordTaskRepository, :count)
      end

      it 'updates the existing entry' do
        expect { described_class.store(task) }
          .to(change { task_ar.reload.name }.to('Task 1')
          .and(change { task_ar.reload.due_at }))
      end
    end
  end

  describe '.find' do
    let(:task_id) { create(:task).id }

    it 'returns an instance of task entity' do
      expect(described_class.find(task_id)).to be_an_instance_of Task::Domain::TaskEntity
    end
  end

  describe '.count' do
    before { create(:task) }
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
      before { create(:task, id: 3) }
      it 'returns next id related to the last entry id ' do
        expect(described_class.next_id).to eq(4)
      end
    end
  end
end
