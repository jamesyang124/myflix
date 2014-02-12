class UsersController < ApplicationController 
  before_action :require_user, only: [:show]

  def new
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(create_user)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
  
    if result.successful?
      flash[:success] = result.status_message
      redirect_to root_path
    else 
      flash.now[:error] = result.status_message
      render :new
    end
  end

  def show
    @user = User.find params[:id]
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else 
      redirect_to expired_token_path
    end
  end 

  private 

  def create_user
    params.require(:user).permit(:full_name, :password, :email, :password_confirmation)
  end
end