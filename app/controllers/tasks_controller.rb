class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.all
      .search_title(params[:title])
      .search_status(params[:status])
      .select_order(params[:order_selected])
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = "登録しました"
      redirect_to tasks_path
    else
      flash[:danger] = "登録できませんでした"
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:notice] = "更新しました"
      redirect_to tasks_path
    else
      flash[:danger] = "更新できませんでした"
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
  
  private
    def task_params
      params.require(:task).permit(:title, :description, :deadline_on, :priority, :status, :user_id)
    end
  
    def set_task
      @task = Task.find(params[:id])
    end
end
