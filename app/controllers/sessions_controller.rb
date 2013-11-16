class SessionsController < ApplicationController
  def edit
  end

  def create
    user = User.find_by(email: params[:email]) 

    if user and user.authenticate(params[:password])
      redirect_to home_path
    else
      render :edit
    end
   end
end