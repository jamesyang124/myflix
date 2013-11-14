class Category < ActiveRecord::Base
  has_many :videos, order: :title

  validates :name, presence: true, uniqueness: true

  def recent_videos
    @videos = self.videos
    @videos.sort! do |x,y| 
      y.updated_at.to_i <=> x.updated_at.to_i
    end 
  end
end