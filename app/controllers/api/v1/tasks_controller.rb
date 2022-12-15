# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApiController
      def create
        created_task = Task.create!(task_params)
        render json: { id: created_task.id }
      end

      def update
        task.update!(task_params)
        render json: { id: task.id }
      end

      def mark_as_completed
        task.completed!
        task.save!

        render status: :no_content
      end

      def mark_as_pending
        task.pending!
        task.save!

        render status: :no_content
      end

      private

      def task_params
        params.require(:task).permit(:name, :description, :due_at)
      end

      def task
        @task ||= Task.find(params[:id])
      end
    end
  end
end
