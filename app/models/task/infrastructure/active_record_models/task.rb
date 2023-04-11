# frozen_string_literal: true

module Task
  module Infrastructure
    module ActiveRecordModels
      class Task < ApplicationRecord
        belongs_to :user, class_name: 'User::Infrastructure::ActiveRecordModels::User'
      end
    end
  end
end
