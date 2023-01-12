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
            type: error[:type],
            message: error[:message],
            details: error[:exception].errors
          }
        }
      end

      private

      attr_reader :error
    end
  end
end
