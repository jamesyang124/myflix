class PagesController < ApplicationController
  def front
    if logged_in?
      redirect_to home_path
    else
      render :front
    end 
  end
end