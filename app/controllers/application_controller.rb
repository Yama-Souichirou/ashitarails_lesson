class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def current_user
    remember_token = User.encrypt(cookies[:user_remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def signed_in?
    @current_user.present?
  end
  
  def authenticate_user!
    redirect_to new_session_path unless signed_in?
  end
end
