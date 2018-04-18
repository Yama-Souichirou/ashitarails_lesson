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
    @task = Task.new(task_params)
  end
  
  def edit
  end
  
  def update
  
  end
  
  def destroy
  end
  
  private
    def task_params
      params.require(:task).permit(:title, :description, :dead, :priority)
    end
    
    def set_task
      @task = Task.find(params[:id])
    end
end
