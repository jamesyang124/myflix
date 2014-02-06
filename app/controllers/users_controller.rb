class UsersController < ApplicationController 
  before_action :require_user, only: [:show]

  def new
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(create_user)
    if @user.valid?
      token = params[:stripeToken]
      
      charge = StripeWrapper::Charge.create(
        :amount => 999, 
        :currency => "usd",
        :card => token,
        :description => "Sign up charge for #{@user.email}."
      )

      if charge.successful?
        @user.save
        handle_invitation(@user)
        AppMailersWorker.delay.perform_async(@user.id, @user.class.to_s, :send_welcome_email)
        flash[:success] = "Thank you for your payment for Myflix."
        redirect_to root_path
      else
        flash.now[:error] = charge.error_message
        render :new
      end
    else
      flash.now[:error] = "Invalid user information, please fill in again."
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

  def handle_invitation(user)
    if invitation = Invitation.find_by(token: params[:invitation_token])
      user.follow(invitation.inviter)
      invitation.inviter.follow(user)
      invitation.update_column(:token, nil)
    end
  end
end