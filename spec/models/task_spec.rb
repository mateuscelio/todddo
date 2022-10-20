# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most(250) }
    it { should validate_length_of(:description).is_at_most(2500) }

    describe 'due_at_cannot_be_in_the_past' do
      let(:task) { build(:task, due_at: 1.day.ago) }

      it 'raises error' do
        task.save
        expect(task.errors.full_messages).to eq(['Due at cannot be in the past'])
      end
    end
  end
end
