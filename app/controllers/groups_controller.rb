class GroupsController < ApplicationController
  
  def index
    @groups = Group.all
  end
  
  def show
  
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    if @group.save!
      flash[:notice] = "グループを作成しました"
      redirect_to groups_path
    else
      flash[:notice] = "むりです"
      render 'new'
    end
  end
  
  def edit
  
  end
  
  def update
  
  end
  
  def destroy
  
  end
  
  private
    def group_params
      params.require(:group).permit(:name, :description, group_users_attributes: [:user_id, :group_id, :_destroy, :id])
    end
end
