class QueueItem < ActiveRecord::Base 
  belongs_to :user
  
  validates_presence_of :position, :user_id, :video_id
end