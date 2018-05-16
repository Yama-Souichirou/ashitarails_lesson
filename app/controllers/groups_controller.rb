class GroupsController < ApplicationController
  
  def index
    @groups = Group.all
  end
  
  def show
    @group = Group.find(params[:id])
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    if @group.save!
      flash[:notice] = "作成しました"
      head :ok
    else
      render json: { messages: group.errors.full_messages }, status: :bad_request
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
