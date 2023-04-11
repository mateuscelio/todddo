# frozen_string_literal: true

module User
  module Infrastructure
    module ActiveRecordModels
      class User < ApplicationRecord
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
        devise :database_authenticatable, :registerable,
               :recoverable, :validatable

        has_many :tasks, class_name: 'Task::Infrastructure::ActiveRecordModels::Task', dependent: :destroy
      end
    end
  end
end
