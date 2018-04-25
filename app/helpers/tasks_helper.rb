module TasksHelper
  def sort_link(column, order, query)
    tasks_path(sort: { column: column, order: order }, task: { title: query.title, status: query.status, priority: query.priority })
  end
end
