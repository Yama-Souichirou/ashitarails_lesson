class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  
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
    @task = Group.find(params[:id]).tasks.build
  end
  
  def show
  end
  
  def create
    @task = Task.new(task_params)
    @task.user_id = @current_user.id
    if @task.save
      flash[:notice] = "タスクを登録しました"
      redirect_to group_path(@task.group.id)
    else
      @errors = @task.errors.full_messages
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:notice] = "更新しました"
      redirect_to group_path(@task.group.id)
    else
      @errors = @task.errors.full_messages
      render 'new'
    end
  end
  
  def destroy
    if @task.destroy
      flash[:notice] = "削除しました"
      redirect_to tasks_path
    else
      flash[:danger] = "削除できませんでした"
      redirect_to tasks_path
    end
  end

  def calendar
    @tasks = Task
      .search_deadlin_on(params[:deadline_on])
      .search_month(params[:start_day], params[:end_day])
    respond_to do |format|
      format.html
      format.json { render 'calendar', handlers: 'jbuilder' }
    end
  end
  
  private
    def task_params
      params.require(:task).permit(:title, :description, :deadline_on, :priority, :status, :group_id, :user_id, :responsible_id, task_labels_attributes: [:task_id, :label_id, :_destroy, :id], task_images_files: [])
    end
    
    def task_search_params
      params.require(:task).permit(:title, :status, :priority, :user_id, :responsible_id, label_ids: [])
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
