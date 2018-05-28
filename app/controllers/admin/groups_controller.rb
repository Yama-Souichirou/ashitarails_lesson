class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_group, only: [:show, :destroy, :edit, :update]

  layout 'admin'

  def index
    @groups = Group.all.includes(:group_users)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:notice] = "作成しました"
      head :ok
    else
      render json: { messages: @group.errors.full_messages }, status: :bad_request
    end
  end

  def edit
    @group.users.build
  end

  def update
    if @group.update(group_params)
      flash[:notice] = "更新しました"
      head :ok
    else
      render json: { messages: @group.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    if @group.destroy
      flash[:notice] = "削除しました"
      redirect_to groups_path
    else
      flash[:danger] = "削除できませんでした"
      redirect_to group_path(@group)
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description, group_users_attributes: [:user_id, :group_id, :_destroy, :id])
  end

  def set_group
    @group = Group.find(params[:id])
  end

end
