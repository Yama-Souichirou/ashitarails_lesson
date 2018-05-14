class SessionsController < ApplicationController
  layout 'login'
  before_action :set_user, only: [:create]
  
  def new
  end
  
  def create
    if @user.authenticate(session_params[:password])
      sign_in(@user)
      flash[:notice] = "ログインしました"
      flash[:close_deadline] = close_deadline_tasks_notification
      flash[:too_deadline] = too_deadline_tasks_notification
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
      p User.find_by!(email: session_params[:email])
      @user = User.find_by!(email: session_params[:email])
    rescue
      flash.now[:danger] = "ユーザーがいません"
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
  
    def close_deadline_tasks_notification
      tasks = @current_user
        .responsibles
        .exclude_complete
        .where("tasks.deadline_on < ?", Date.today + 2.day)
      return "期日が3日以内のタスクが#{tasks.size}件あります" if tasks.present?
    end
  
    def too_deadline_tasks_notification
      tasks = @current_user
        .responsibles
        .exclude_complete
        .where("tasks.deadline_on < ?", Date.today)
      return "期日が過ぎているタスクが#{tasks.size}件あります" if tasks.present?
    end
end
