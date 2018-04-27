class LabelsController < ApplicationController
  
  def index
    @label = Label.find_by(name: params[:name])
    respond_to do |format|
      format.html
      format.json { render json: @label }
    end
  end
end
