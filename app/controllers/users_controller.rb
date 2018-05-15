class UsersController < ApplicationController
  before_action :set_user
	before_action :authenticate_user!

	def show
	end
  
  def update
		if @user.update(user_params)
			flash[:notice] = "更新しました"
			redirect_to user_path(@user)
		else
			flash[:danger] = "更新できませんでした"
			redirect_to user_path(@user)
		end
	end
  
  private
    def user_params
			params.require(:user).permit(:image)
		end
  
    def set_user
			@user = User.find(params[:id])
		end
end
