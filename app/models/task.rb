# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 250 }
  validates :description, length: { maximum: 2500 }
  validate :due_at_cannot_be_in_the_past
  validates :completed, inclusion: { in: [true, false] }

  private

  def due_at_cannot_be_in_the_past
    errors.add(:due_at, 'cannot be in the past') if due_at.present? && due_at < Time.zone.now
  end
end
