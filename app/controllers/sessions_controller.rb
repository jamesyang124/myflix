class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def edit
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email]) 

    if user and user.authenticate(params[:password])
      login_user!(user)
    else
      flash.now[:info] = "Sign in failed, please check the sign-in information or register a new one."
      render :edit
    end
  end

  def destroy 
    session[:user_id] = nil
    redirect_to root_path, notice: 'You have signed out!'
  end

  private

  def login_user!(user)
    session[:user_id] = user.id
    redirect_to home_path, notice: 'You have signed in! Enjoy!'
  end
end