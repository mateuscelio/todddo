# frozen_string_literal: true

class AddCompletedToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :completed, :boolean, default: false, null: false
  end
end
