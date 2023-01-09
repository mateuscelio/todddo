class TaskMailer < ApplicationMailer
  def task_updated(task_id, emails)
    @task = Task.find(task_id)

    mail(
      to: emails,
      subject: "Task #{task_id} was updated!"
    )
  end
end
