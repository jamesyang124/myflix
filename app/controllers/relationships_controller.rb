class RelationshipsController < ApplicationController 
  before_action :require_user, only: [:index, :destroy, :create]

  def index
    @relationships = current_user.following_relationships 
  end

  def create
    leader = User.find(params[:leader_id])
    if current_user.can_follows?(leader)
      Relationship.create(follower: current_user, leader_id: params[:leader_id])
    else
      flash[:error] = "Can not follow same user again."
    end
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    if current_user == relationship.follower
      relationship.destroy
    else 
      flash[:error] = "It's not allowed to delete the relationship which does not bound with #{current_user.full_name}."
    end
    redirect_to people_path
  end


end