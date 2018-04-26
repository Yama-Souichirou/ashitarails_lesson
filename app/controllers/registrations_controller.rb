class RegistrationsController < ApplicationController
  before_action :set_user, only: [:edit , :update, :destroy]
  layout 'login'
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "アカウントを登録しました。"
      redirect_to admin_users_path
    else
      flash[:danger] = "登録できませんでした"
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "アカウントを更新しました。"
      redirect_to admin_users_path
    else
      flash[:danger] = "更新できませんでした"
      render "new"
    end
  end
  
  def destroy
    if @user.destroy
      flash[:danger] = "削除しました"
      redirect_to admin_tasks_path
    else
      flash[:danger] = "削除できませんでした"
      redirect_to admin_tasks_path
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  
    def set_user
      @user = User.find(params[:id])
    end
end
