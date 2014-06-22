class QueueItemsController < ApplicationController 
  before_action :require_user, :require_activation 
  
  caches_action :index
  def index
    @queue_items = current_user.queue_items.order("position ASC")
  end

  def create 
    expire_action action: [:index]
    @queue_items = current_user.queue_items
    put_video_to_queue(@queue_items)
    redirect_to queue_items_path
  end

  def update_queue
    expire_action action: [:index]
    begin
      if params.include? :queue_items
        update_queue_items 
      else
        raise ArgumentError
      end
      current_user.normalize_queue_items_position
    rescue ActiveRecord::RecordInvalid
      flash[:error] = 'Invalid input for the update'
    rescue ArgumentError
      flash[:error] = 'No queue items for the update'
    end
    redirect_to queue_items_path
  end

  def destroy
    expire_action action: [:index]
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
      QueueItem.destroy(params[:id])
      current_user.normalize_queue_items_position
    end
  end

  def update_queue_items
    ActiveRecord::Base.transaction do 
      params[:queue_items].each do |q|
        item = QueueItem.find(q[:id])
        item.update_attributes!(position: q[:position], rating: q[:rating]) if item.user == current_user
      end
    end
  end
end