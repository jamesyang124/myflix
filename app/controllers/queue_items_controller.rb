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

  def destroy
    destroy_queue_item(params[:id])
    redirect_to queue_items_path  
  end

private 

  def put_video_to_queue(queue_items)
    queue_items.create(user: current_user, video_id: params[:video_id], position: new_position) unless video_in_queue?(params[:video_id])
  end

  def new_position
    current_user.queue_items.count + 1
  end

  def video_in_queue?(video_id)
    current_user.queue_items.map(&:video).include?(Video.find(video_id)) unless Video.where(id: video_id).blank?
  end

  def destroy_queue_item(queue_id)
    if current_user == QueueItem.find(queue_id).user
      index = current_user.queue_items.sort_by!(&:position).index(QueueItem.find(queue_id))

      current_user.queue_items.sort_by!(&:position).drop(index).each do |q| 
        q.position -=1 
        q.save
      end
      QueueItem.destroy(queue_id)
    end
  end
end