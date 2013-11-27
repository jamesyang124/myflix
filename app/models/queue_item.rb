class QueueItem < ActiveRecord::Base 
  belongs_to :user
  
  validates_presence_of :position, :video_id, :user_id
end