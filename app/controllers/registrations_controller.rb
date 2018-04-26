class RegistrationsController < ApplicationController
  layout 'login'
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "アカウントを登録しました。ログインしてください"
      redirect_to new_session_path
    else
      flash[:danger] = "登録できませんでした"
      render "new"
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
end
