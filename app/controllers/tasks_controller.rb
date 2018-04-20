class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.all
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
  
  end
  
  def edit
  
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
  private
    def task_params
      params.require(:task).permit(:title, :description, :deadline_on, :priority, :status, :user_id)
    end
  
    def set_params
      @task = Task.find(params[:id])
    end
end
