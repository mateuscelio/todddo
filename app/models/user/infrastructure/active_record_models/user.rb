# frozen_string_literal: true

module User
  module Infrastructure
    module ActiveRecordModels
      class User < ApplicationRecord
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
        devise :database_authenticatable, :registerable,
               :recoverable, :validatable
      end
    end
  end
end
