# frozen_string_literal: true

module Errors
  class Unauthorized < StandardError; end

  class InvalidEntity < StandardError
    attr_reader :errors

    def initialize(errors)
      super('Invalid Entity!')
      @errors = errors
    end
  end
end
