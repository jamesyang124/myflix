class SessionsController < ApplicationController
  before_action :require_user, :require_activation, only: [:destroy]

  def new
    redirect_to home_path if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email]) 

    if @user and @user.authenticate(params[:password])
      if @user.active?
        login_user!(@user)
      else
        session[:user_id] = @user.id
        flash[:error] = "Your account has been deactived, please contact customer service or subscribe service now."
        redirect_to plans_path
      end
    else
      flash.now[:info] = "Sign in failed, please check the sign-in information or register a new one."
      render :new
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