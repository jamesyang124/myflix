class Category < ActiveRecord::Base
  #has_many :videos, -> { order(:title) }
  has_many :videos, -> { order("updated_at DESC") }

  validates :name, presence: true, uniqueness: true

  def recent_videos
    videos.first(6)
  end

#  def recent_videos
#    @videos = self.videos
#    @videos.sort_by! do |x| 
#      -(x.updated_at.to_i)
#    end
#    #binding.pry
#    @videos.take(6)
#  end
end