# frozen_string_literal: true

class TasksController < ApplicationController
  def create
    created_task = Task.create!(create_params)
    render json: { id: created_task.id }
  end

  private

  def create_params
    params.permit(:name, :description, :due_at)
  end
end
