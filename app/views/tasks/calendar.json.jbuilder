json.array!(@tasks) do |task|
  json.id          task.id
  json.title       task.title
  json.created     task.created_at.strftime("%Y/%m/%d")
  json.responsible task.responsible.username
  json.user        task.user.username
end
