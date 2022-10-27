# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

      private

      def record_invalid(exception)
        error = {
          type: 'ValidationError',
          message: 'Validation error',
          exception:

        }
        render json: ErrorSerializer.new(error).serializable_hash, status: :unprocessable_entity
      end
    end
  end
end
