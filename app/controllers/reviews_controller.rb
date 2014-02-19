class ReviewsController < ApplicationController
  before_action :require_user
  def create
    @video = Video.find(params[:video_id])
    if @video.reviews.build(review_params.merge!(user: current_user)).save
      redirect_to @video
    else
      flash.now[:error] = "Lacking information for the review, please fill in and try again."
      @video = VideoDecorator.decorate(@video.reload)
      # or @video = VideoDecorator.decorate(Video.find(params[:video_id]))
      render 'videos/video_show'
    end
  end

private

  def review_params
    params.require(:review).permit!
  end
end