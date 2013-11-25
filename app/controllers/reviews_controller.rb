class ReviewsController < ApplicationController
  before_action :require_user
  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.video = @video

    if @review.save
      redirect_to @video
    else
      flash.now[:error] = "Lacking information for the review, please fill in and try again."
      render 'videos/video_show' 
    end
  end

private

  def review_params
    params.require(:review).permit!
  end
end