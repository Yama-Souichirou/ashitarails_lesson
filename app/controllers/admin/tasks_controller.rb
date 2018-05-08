class Admin::TasksController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task
      .includes(:user)
      .search(params[:task])
      .order(sortable_conditions_str(params[:sort]))
      .page(params[:page])
    @task = Task.new
    @q = params[:task].present? ? Task.new(task_search_params) : Task.new(status: nil, priority: nil)
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    @task.user_id = @current_user.id
    if @task.save
      flash[:notice] = "タスクを登録しました"
      head :ok
    else
      render json: { messages: @task.errors.full_messages }, status: :bad_request
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:notice] = "タスクを登録しました"
      head :ok
    else
      render json: { messages: @task.errors.full_messages }, status: :bad_request
    end
  end
  
  def destroy
    if @task.destroy
      flash[:notice] = "削除しました"
      redirect_to admin_tasks_path
    else
      flash[:danger] = "削除できませんでした"
      redirect_to admin_tasks_path
    end
  end
  
  private
    def task_params
      params.require(:task).permit(:title, :description, :deadline_on, :priority, :status, :user_id, :responsible_id, task_labels_attributes: [:task_id, :label_id, :_destroy, :id])
    end
    
    def task_search_params
      params.require(:task).permit(:title, :status, :priority, :user_id, :responsible)
    end
    
    def set_task
      @task = Task.find(params[:id])
    end

    def sort_str(order, toggle: false)
      if toggle
        order == "ASC" ? "DESC" : "ASC"
      else
        order == "ASC" ? "ASC" : "DESC"
      end
    end

    def sortable_conditions_str(params)
      if params.present?
        sort = sort_str(params[:order])
        @sort = sort_str(sort, toggle: true)
        return "#{params[:column]} #{sort}"
      end
    end
end
