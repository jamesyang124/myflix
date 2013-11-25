class VideosController < ApplicationController 
  before_action :require_user, except: [:front]

  def index 
    @videos = Video.all
    @categories = Category.all
  end

  def show 
    @video = Video.find params[:id]
    render 'video_show'
  end

  def search
    @items = Video.search_by_title_categorized(params[:search])
  end

  def add_review
    
  end
end