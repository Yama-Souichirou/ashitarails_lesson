class Admin::GroupUsersController < ApplicationController
  
  def destroy
    @group_user = GroupUser.find_by(group_id: params[:group_id], user_id: params[:user_id])
    if @group_user.destroy
      flash[:notice] = "プロジェクトから削除しました"
      redirect_to admin_groups_path
    else
      flash[:danger] = "プロジェクトから削除できませんでした"
      redirect_to :back
    end
  end
end
