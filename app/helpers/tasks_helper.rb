module TasksHelper
  def sort_link(column, order, query)
    tasks_path(
      sort: {
        column: column,
        order: order
      },
      task: {
        title: query.title,
        status: query.status,
        priority: query.priority,
        responsible_id: query.responsible_id,
        user_id: query.user_id,
      }
    )
  end
end
