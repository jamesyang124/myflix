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

  def update_queue
    params[:queue_items].each do |q|
      item = QueueItem.find(q[:id])
      item.update_attributes(position: q[:position])
    end
    normalize_position
    redirect_to queue_items_path
  end

  def destroy
    destroy_queue_item
    redirect_to queue_items_path  
  end

private 

  def put_video_to_queue(queue_items)
    queue_items.create(
        user: current_user, 
        video_id: params[:video_id], 
        position: new_position
      ) unless video_in_queue?(params[:video_id])
  end

  def new_position
    current_user.queue_items.count + 1
  end

  def video_in_queue?(video_id)
    current_user.queue_items.map(&:video).include?(Video.find(video_id)) unless Video.where(id: video_id).blank?
  end

  def destroy_queue_item
    item = QueueItem.find(params[:id])
    if current_user.queue_items.include?(item)
      normalize_position
      QueueItem.destroy(params[:id])
    end
  end

  def normalize_position
    current_user.queue_items.sort_by(&:position).each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end
end