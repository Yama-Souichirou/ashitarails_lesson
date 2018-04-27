class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit]
  layout 'admin'
  
  def index
    @users = User
      .search(params[:user])
    @q = params[:user].present? ? User.new(search_user_params) : User.new
  end
  
  def show
  end
  
  private
    def search_user_params
      params.require(:user).permit(:username, :created_at)
    end
  
    def set_user
      @user = User.find(params[:id])
    end
end
