class UserSignup 
  attr_accessor :user
  attr_reader :status_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?  
      customer = StripeWrapper::Customer.create(
        :card => stripe_token,
        :user => @user
      )

      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        handle_invitation(@user, invitation_token)
        AppMailersWorker.delay.perform_async(@user.id, @user.class.to_s, :send_welcome_email)
        
        @status = :success
        @status_message = "Thank you for your payment for Myflix."
      else
        @status = :failed
        @status_message = customer.error_message
      end
    else
      @status = :failed
      @status_message = "Invalid user information, please fill in again."
    end
    self
  end

  def recharge(stripe_token)
    if User.find(@user)
      customer = StripeWrapper::Customer.create(
        :card => stripe_token,
        :user => @user
      )

      if customer.successful?
        @user.update_column(:customer_token, customer.customer_token)

        AppMailersWorker.delay.perform_async(@user.id, @user.class.to_s, :send_welcome_email)
        @status = :success
        @status_message = "Thank you for your payment for Myflix."
      else
        @status = :failed
        @status_message = customer.error_message
      end
    else
      @status = :failed
      @status_message = "Invalid user information, please fill in again."
    end
    self
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(user, invitation_token)
    if invitation_token and invitation = Invitation.find_by(token: invitation_token)
      user.follow(invitation.inviter)
      invitation.inviter.follow(user)
      invitation.update_column(:token, nil)
    end
  end

end