class QueueItemsController < ApplicationController 
  before_action :require_user
  
  def index
    @queue_items = current_user.queue_items.order("position ASC")
  end

  def create 
    @queue_items = current_user.queue_items
    put_video_to_queue(@queue_items)
    redirect_to queue_items_path
  end

private 

  def put_video_to_queue(queue_items)
    queue_items.create(user: current_user, video_id: params[:video_id], position: new_position) unless video_in_queue?
  end

  def new_position
    current_user.queue_items.count + 1
  end

  def video_in_queue?
    current_user.queue_items.map(&:video).include?(Video.find(params[:video_id]))
  end
end