class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.reviews_total_rate.present? ? "Rating: #{object.reviews_total_rate} / 5.0" : "Rating: N/A" 
  end
end