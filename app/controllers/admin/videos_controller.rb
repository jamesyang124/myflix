class Admin::VideosController < AdminsController 
  before_action :require_user
  #cache_sweeper :videos_sweeper, :only => [:create]

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(create_video)
    if @video.save
      expire_fragment ["videos_category", "#{@video.category_id}"]
      flash[:success] = "You have successfully added the new video #{@video.title}."
      redirect_to new_admin_video_path
    else
      flash[:error] = "You are failed to add the video, please try again."
      render :new
    end
  end

  private

  def create_video
    params.require(:video).permit!
  end
end