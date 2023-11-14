# frozen_string_literal: true

module Api
  module V1
    class TasksController < ApiController
      before_action :authenticate_user!

      def create
        created_task = Task::UseCases::CreateTask.new(
          **task_params,
          task_repository: Task::Infrastructure::ActiveRecordTaskRepository
        ).call

        render json: { id: created_task.id }
      end

      def update
        updated_task = Task::UseCases::UpdateTask.new(
          id: params[:id],
          attributes: task_params,
          task_repository: Task::Infrastructure::ActiveRecordTaskRepository,
          updated_by: @user,
          validate_ownership: Task::Domain::ValidateOwnership,
          pub_sub: PubSubRabbitMq.instance
        ).call

        render json: { id: updated_task.id }
      end

      def mark_as_completed
        Task::UseCases::MarkTaskAsCompleted.new(
          id: params[:id],
          task_repository: Task::Infrastructure::ActiveRecordTaskRepository
        ).call

        render status: :no_content
      end

      def mark_as_pending
        Task::UseCases::MarkTaskAsPending.new(
          id: params[:id],
          task_repository: Task::Infrastructure::ActiveRecordTaskRepository
        ).call

        render status: :no_content
      end

      private

      def task_params
        params.require(:task)
              .permit(:name, :description, :due_at)
              .to_h
              .symbolize_keys
              .merge(user_id: @user.id)
      end
    end
  end
end
