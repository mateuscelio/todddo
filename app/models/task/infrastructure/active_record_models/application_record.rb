# frozen_string_literal: true

module Task
  module Infrastructure
    module ActiveRecordModels
      class ApplicationRecord < ActiveRecord::Base
        primary_abstract_class
      end
    end
  end
end
