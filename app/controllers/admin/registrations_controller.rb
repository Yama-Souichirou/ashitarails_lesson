class Admin::RegistrationsController < ApplicationController
  before_action :set_user, only: [:edit , :update, :destroy]
  before_action :authenticate_admin!
  layout 'admin'
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "アカウントを登録しました。"
      head :ok
    else
      render json: { messages: @user.errors.full_messages }, status: :bad_request
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "アカウントを登録しました。"
      head :ok
    else
      render json: { messages: @user.errors.full_messages }, status: :bad_request
    end
  end
  
  def destroy
    if @user.destroy
      flash[:notice] = "削除しました"
      redirect_to admin_users_path
    else
      flash[:danger] = "削除できませんでした"
      redirect_to admin_users_path
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
    end
  
    def set_user
      @user = User.find(params[:id])
    end
end
