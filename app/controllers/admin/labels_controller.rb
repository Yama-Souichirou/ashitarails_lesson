class Admin::LabelsController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"
  
  def index
    @labels = Label.all
    @label = Label.new
  end
  
  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:notice] = "登録しました"
      redirect_to admin_labels_path
    else
      flash[:danger] = "登録できません"
      redirect_to admin_labels_path
    end
  end
  
  private
  def label_params
    params.require(:label).permit(:name)
  end
end
