class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'
  
  def index
    @users = User
      .search(params)
    @q = params[:user].present? ? User.new(search_user_params) : User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  private
    def search_user_params
      params.require(:user).permit(:username, :created_at)
    end
end
