class ForgotPasswordsController < ApplicationController 
  def create
    @user = User.where(email: params[:email]).first
    if @user
      AppMailersWorker.delay.perform_async(@user.id, @user.class.to_s, :send_forgot_password)
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cannot be blank." : "Email input does not exist in system."
      redirect_to forgot_password_path
    end
  end
end