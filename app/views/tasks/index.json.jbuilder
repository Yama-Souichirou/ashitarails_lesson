json.tasks @tasks do |task|
  json.id             task.id
  json.title          task.title
  json.created        task.created_at.strftime("%Y-%-m-%-d")
  json.deadline_on    task.deadline_on.strftime("%Y-%-m-%-d")
  json.priority       task.human_priority
  json.priority_class task.priority_color_class
  json.status         task.human_status
  json.status_class   task.status_color_class
  json.responsible    task.responsible.username.truncate(8)
  json.user           task.user.username.truncate(8)
  json.group_id       task.group.id
  json.group          task.group.name

  json.labels task.labels do |label|
    json.id   label.id
    json.name label.name
  end
end
json.close_dead_tasks @tasks.close_deadline_tasks do |task|
  json.id             task.id
  json.title          task.title
  json.created        task.created_at.strftime("%Y-%-m-%-d")
  json.deadline_on    task.deadline_on.strftime("%Y-%-m-%-d")
  json.priority       task.human_priority
  json.priority_class task.priority_color_class
  json.status         task.human_status
  json.status_class   task.status_color_class
  json.responsible    task.responsible.username.truncate(8)
  json.user           task.user.username.truncate(8)
  json.group_id       task.group.id
  json.group          task.group.name

  json.labels task.labels do |label|
    json.id   label.id
    json.name label.name
  end
end
