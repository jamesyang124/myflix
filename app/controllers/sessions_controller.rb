class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def edit
  end

  def create
    user = User.find_by(email: params[:email]) 

    if user and user.authenticate(params[:password])
      login_user!(user)
    else
      render :edit
    end
  end

  def destroy 
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def login_user!(user)
    session[:user_id] = user.id
    redirect_to root_path
  end
end