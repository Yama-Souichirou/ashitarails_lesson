class LabelsController < ApplicationController
  
  def index
    @label = Label.find_by(name: params[:name])
    @task_label =  @label.task_labels.find_by(task_id: params[:task_id])
    @task_label.destroy if @task_label.present?
    respond_to do |format|
      format.html
      format.json { render json: @label }
    end
  end
end
