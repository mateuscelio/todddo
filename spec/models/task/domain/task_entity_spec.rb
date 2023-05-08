# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task::Domain::TaskEntity, type: :class do
  let(:name) { 'Name' }
  let(:description) { '' }
  let(:due_at) { Time.now + 1.day }
  let(:completed) { false }
  let(:id) { 1 }
  let(:user_id) { 1 }

  subject { described_class.new(id:, name:, description:, due_at:, completed:, user_id:) }

  describe '#new' do
    context 'without name' do
      let(:name) { '' }

      it 'raises validation error' do
        subject
      rescue Errors::InvalidEntity => e
        expect(e.errors).to eq(['Name cannot be empty'])
      end
    end

    context 'with name too long' do
      let(:name) { 'a' * 251 }

      it 'raises validation error' do
        subject
      rescue Errors::InvalidEntity => e
        expect(e.errors).to eq(['Name too long'])
      end
    end

    context 'with description too long' do
      let(:description) { 'a' * 2501 }

      it 'raises validation error' do
        subject
      rescue Errors::InvalidEntity => e
        expect(e.errors).to eq(['Description too long'])
      end
    end

    context 'with due_at in the past' do
      let(:due_at) { Time.now - 1.day }

      it 'raises validation error' do
        subject
      rescue Errors::InvalidEntity => e
        expect(e.errors).to eq(['Due at cannot be in the past'])
      end
    end
  end

  describe '#clone_with' do
    let(:description) { 'test desc' }
    let(:name) { 'test name' }
    let(:user_id) { 1 }

    subject { described_class.create(id:, user_id:, name:, description:, due_at:) }

    it 'clones instance with specified valued' do
      cloned_task = subject.clone_with(id: nil, name: 'new_name', completed: true)

      expect(cloned_task).to_not eq(subject)
      expect(cloned_task.to_h).to include(
        name: 'new_name',
        id: nil,
        description: 'test desc',
        completed: true,
        due_at: subject.due_at,
        created_at: subject.created_at,
        updated_at: subject.updated_at
      )
    end
  end

  describe '.mark_as_completed' do
    it 'clone task with completed as true' do
      pending_task = described_class.mark_as_completed(subject)

      expect(pending_task).not_to eq(subject)
      expect(pending_task.completed).to eq true
    end
  end

  describe '.mark_as_pending' do
    let(:completed) { true }

    it 'clone task with completed as false' do
      pending_task = described_class.mark_as_pending(subject)

      expect(pending_task).not_to eq(subject)
      expect(pending_task.completed).to eq false
    end
  end
end
