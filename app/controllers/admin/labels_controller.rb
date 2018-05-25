class Admin::LabelsController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"
  
  def index
    @labels = Label.all
    @label  = Label.new

    respond_to do |format|
      format.html
      format.json {}
    end
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
  
  def destroy
    @label = Label.find(params[:id])
    if @label.destroy
      flash[:notice] = "削除しました"
      redirect_to admin_labels_path
    else
      flash[:danger] = "削除できませんでした"
      redirect_to admin_labels_path
    end
  end
  
  private
  def label_params
    params.require(:label).permit(:name)
  end
end
