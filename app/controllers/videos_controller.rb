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
    @categories = []
    @videos.each do |v|
      if v.category
        @categories << v.category if !@categories.include?(v.category)
      else

        @categories << 'Uncategoried' if !@categories.include?('Uncategoried')
      end
    end
    render 'search'
  end
end