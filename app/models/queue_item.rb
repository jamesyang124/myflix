class QueueItem < ActiveRecord::Base 
  belongs_to :user
  belongs_to :video

  validates_presence_of :position, :user_id, :video_id
  validates_uniqueness_of :video_id, scope: :user_id

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

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
    category.name
  end
end