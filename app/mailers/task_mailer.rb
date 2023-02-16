# frozen_string_literal: true

class TaskMailer < ApplicationMailer
  def task_updated(task_id, emails)
    @task = Task::Infrastructure::ActiveRecordTaskRepository.find(task_id)
    mail(
      to: emails,
      subject: "Task #{task_id} was updated!"
    )
  end
end
