class RelationshipsController < ApplicationController 
  before_action :require_user, only: [:index, :destroy]

  def index
    @relationships = current_user.following_relationships 
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