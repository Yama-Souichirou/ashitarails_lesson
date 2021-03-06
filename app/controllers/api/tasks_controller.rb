class Api::TasksController < ApplicationController

  def index
    @tasks = Task.search(params)
    render 'index', handlers: 'jbuilder'
  end

  def update
    ids = params[:task_ids].map { |id| id.to_i }
    @tasks = Task.where(id: ids)
    if @tasks.update_all(status: 3)
      @tasks = Task
        .where(group_id: @current_user.groups.ids)
        .includes(:user)
        .search(params["task"])
        .page(params[:page])
      render json: { message: "更新しました", handlers: 'jbuilder' }, status: :ok
    else
      render json: { message: "更新できませんでした" }, status: :bad_request
    end
  end

  def destroy
    ids = params[:task_ids].map { |id| id.to_i }
    @tasks = Task.where(id: ids)
    if @tasks.delete_all
      flash[:notice] = "一括削除しました"
      render json: { url: "#{tasks_path}" }, status: :ok
    else
      render json: { message: "削除できませんでした" }, status: :bad_request
    end
  end
end
