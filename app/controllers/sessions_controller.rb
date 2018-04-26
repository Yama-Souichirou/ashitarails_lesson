class SessionsController < ApplicationController
  layout 'login'
  before_action :set_user, only: [:create]
  
  def new
  end
  
  def create
    if @user.authenticate(session_params[:password])
      sign_in(@user)
      after_sign_in_path
    else
      flash[:danger] = "ログインできませんでした"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  private
    def set_user
      @user = User.find_by!(mail: session_params[:mail])
    rescue
      flash.now[:danger] = t('.flash.invalid_mail')
      render 'new'
    end
  
    def session_params
      params.require(:session).permit(:email, :password)
    end
  
    def sign_in(user)
      remember_token = User.new_remember_token
      cookies.permanent[:user_remember_token] = remember_token
      user.update(remember_token: User.encrypt(remember_token))
      @current_user = user
    end
  
    def after_sign_in_path
      redirect_to root_path
    end
  
    def sign_out
      @current_user = nil
      cookies.delete(:user_remember_token)
    end
end
