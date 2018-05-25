json.array!(@labels) do |label|
  json.id          label.id
  json.name       label.name
  json.tasks_size     label.tasks.size
end
