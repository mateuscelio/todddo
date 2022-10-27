# frozen_string_literal: true

module Api
  module V1
    class ErrorSerializer
      def initialize(error)
        @error = error
      end

      def serializable_hash
        {
          error: {
            type: @error[:type],
            message: @error[:message],
            details: @error[:exception].record.errors.full_messages
          }
        }
      end
    end
  end
end
