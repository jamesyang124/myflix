class QueueItemsController < ApplicationController 
  before_action :require_user
  
  def index
    @queue_items = current_user.queue_items.order("position ASC")
  end

  def create 
    @queue_items = current_user.queue_items
    @queue_items.create(user: current_user, video_id: params[:video_id], position: @queue_items.count + 1) unless @queue_items.map(&:video).include?(Video.find(params[:video_id]))
    redirect_to queue_items_path
  end
end