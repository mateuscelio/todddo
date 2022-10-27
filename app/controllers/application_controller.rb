# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def record_invalid(exception)
    render json: {
      error: {
        type: 'ValidationError',
        message: 'Validation error',
        details: exception.record.errors.full_messages
      }
    }, status: :unprocessable_entity
  end
end
