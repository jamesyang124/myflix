class QueueItem < ActiveRecord::Base 
  belongs_to :user
  belongs_to :video

  validates_presence_of :position, :user_id, :video_id
  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position, { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  def rating= (new_rating)
    if review
      if new_rating == ""
        review.update_column(:rating, nil)
      else 
        review.update_column(:rating, new_rating)
      end
    else 
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.name
  end

private

  def review
    @review ||= Review.where(user: user, video: video).last
  end
end