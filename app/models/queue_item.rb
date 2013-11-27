class QueueItem < ActiveRecord::Base 
  belongs_to :user
  belongs_to :video

  validates_presence_of :position, :user, :video

  def video_title
    video.title
  end

  def rating
    reviews = Review.where(user: user, video: video)
    total_rate = 0.00
    total_rate = reviews.reduce(total_rate) do |sum, c| 
      sum += c.rating
    end
    unless reviews.blank?
      total_rate /= reviews.count 
      total_rate.round(1)
    end
  end

  def category_name
    video.category.name
  end

  def category
    video.category
  end
end