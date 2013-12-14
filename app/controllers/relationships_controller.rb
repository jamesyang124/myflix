class RelationshipsController < ApplicationController 
  before_action :require_user, only: [:index]

  def index
    #render 'relationships/index'
  end

  def destroy
    
  end
end