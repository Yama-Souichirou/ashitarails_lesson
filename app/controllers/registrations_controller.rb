class RegistrationsController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!

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

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role, :image)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
