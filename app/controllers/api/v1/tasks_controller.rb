# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApiController
      def create
        created_task = Task.create!(create_params)
        render json: { id: created_task.id }
      end

      private

      def create_params
        params.require(:task).permit(:name, :description, :due_at)
      end
    end
  end
end
