class PlansController < ApplicationController 
  before_action :require_user

  def index
    @payments = Payment.where(user_id: current_user.id).reload
    if customer_token = current_user.customer_token and retrieve_stripe_subscriptions(customer_token)
      render :index
    else
      flash[:info] = "We can not find your billing information, please contact customer service."
      redirect_to root_path
    end
  end

  def create
    @user = current_user
    result = UserSignup.new(@user).recharge(params[:stripeToken])
    if result.successful?
      flash[:success] = result.status_message    
      redirect_to home_path
    else
      flash.now[:error] = result.status_message
      @payments = Payment.where(user_id: current_user.id)
      customer_token = current_user.customer_token
      if customer_token and retrieve_stripe_subscriptions(customer_token)
        render :index
      else
        flash[:info] = "We can not find your billing information, please contact customer service."
        redirect_to root_path
      end
    end    
  end

  def destroy
    customer_token = current_user.customer_token
    begin
      customer = Stripe::Customer.retrieve(customer_token)
      customer.subscriptions.retrieve(StripeWrapper::Customer.retrieve(customer_token).data.last.id).delete
      current_user.deactivate!
      flash[:info] = "Your subscription will be end at the next billing date."
      redirect_to home_path
    rescue => e 
      flash[:info] = "Wrong request for canceling subscription, please contact customer service."
      redirect_to plans_path
    end
  end

  private

  def retrieve_stripe_subscriptions(customer_token = nil) 
    begin
      @subscriptions = Payment.where(user_id: current_user).first
      @recent_sub_plan = "Myflix_base_plan" 
      @recent_sub_period_end = "#{Time.at(@subscriptions.end_date).strftime("%m/%d/%Y")}"
      @recent_sub_amount = @subscriptions.amount/100.0
      true
    rescue Stripe::CardError => e 
      false
    end
  end
end