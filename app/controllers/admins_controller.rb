class AdminsController < ApplicationController 
  before_action :require_admin 

  private

  def require_admin
    if !current_user.admin
      flash[:error] = "You have no permission to view the page."
      redirect_to home_path
    end
  end
end