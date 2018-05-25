class TasksMailer < ActionMailer::Base
  default from: "souichirou19960210@gmail.com"


  def send_responsible_task(task)
    @task = task
    mail to: task.responsible.email, subject: "【Ashita Task Management】#{task.responsible.email}さんにタスクが登録されました"
  end
end
