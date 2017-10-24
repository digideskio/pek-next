class PostsController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def index
    @group = Group.find(params[:group_id])
    @membership = Membership.find(params[:membership_id])
  end

  def create
    group = Group.find(params[:group_id])
    membership = Membership.find(params[:membership_id])
    post_type_id = params[:post_type_id].to_i
    if CreatePost.call(group, membership, post_type_id)
      redirect_to group_path(group)
    else
      redirect_to :back
    end
  end

  def destroy
    Post.delete(params[:id])
    redirect_to :back
  end

end
