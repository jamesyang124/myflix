class PasswordResetsController < ApplicationController 
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token 
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      flash[:success] = "You have successfully reset password."
      user.generate_token
      user.password = params[:password]
      user.save
      redirect_to sign_in_path
    else 
      redirect_to expired_token_path
    end
  end
end