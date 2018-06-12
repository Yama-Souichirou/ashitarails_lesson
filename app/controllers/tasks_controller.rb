class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  
  def index
    @groups = @current_user.groups
    @tasks = Task
      .where(group_id: @groups.ids)
      .includes(:user)
      .search(params["task"])
      .page(params[:page])
    @q = Task.new(status: nil, priority: nil)

    respond_to do |format|
      format.html {}
      format.json { render "index", handlers: "jbuilder" }
    end
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
      TasksMailer.send_responsible_task(@task).deliver_now
      flash[:notice] = "タスクを登録しました"
      redirect_to task_path(@task)
    else
      @errors = @task.errors.full_messages
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      TasksMailer.send_responsible_task(@task).deliver_now
      flash[:notice] = "更新しました"
      redirect_to task_path(@task)
    else
      @errors = @task.errors.full_messages
      render 'edit'
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
  end
  
  private
    def task_params
      params.require(:task).permit(:title, :description, :deadline_on, :priority, :status, :group_id, :user_id, :responsible_id, task_labels_attributes: [:task_id, :label_id, :_destroy, :id], task_images_files: [])
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
