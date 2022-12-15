# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most(250) }
    it { should validate_length_of(:description).is_at_most(2500) }
    it { should validate_inclusion_of(:completed).in_array([true, false]) }

    it 'validates that due_at cannot be in the past' do
      task = build(:task, due_at: 1.day.ago)
      task.save
      expect(task.errors.full_messages).to eq(['Due at cannot be in the past'])
    end
  end
end
