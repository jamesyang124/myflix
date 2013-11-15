class VideosController < ApplicationController 
  
  def index 
    @videos = Video.all
    @categories = Category.all
  end

  def show 
    @video = Video.find params[:id]
    render 'video_show'
  end

  def search
    @videos = Video.search_by_title(params[:search])
    @categories = category_by_video_title(@videos)
    render 'search'
  end

  def front 
    
  end

  private

  def category_by_video_title(videos)
    video_categories = []
    videos.each do |v|
      if v.category
        video_categories << v.category if !video_categories.include?(v.category)
      else
        video_categories << 'Uncategoried' if !video_categories.include?('Uncategoried')
      end
    end
    video_categories
  end
end