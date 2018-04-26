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
        riority: query.priority,
        responsible: @q.responsible,
        user_id: @q.user_id
      }
    )
  end
end
