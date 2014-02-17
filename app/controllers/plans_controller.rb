class PlansController < ApplicationController 
  before_action :require_user

  def index
    @payments = Payment.where(user_id: current_user)
    customer_token = current_user.customer_token
    unless customer_token and retrieve_stripe_subscriptions(customer_token)
      flash[:info] = "We can not find your billing information, please contact customer service."
      redirect_to root_path
    end
  end

  def create
    
  end

  private

  def retrieve_stripe_subscriptions(customer_token = nil) 
    begin
      @subscriptions = StripeWrapper::Customer.retrieve(customer_token)
      @recent_sub_plan = @subscriptions.data.last.plan.name
      @recent_sub_period_end = Time.at(@subscriptions.data.last.current_period_end).strftime("%m/%d/%Y")
      @recent_sub_amount = @subscriptions.data.last.plan.amount/100.0
      true
    rescue Stripe::CardError => e 
      flash[:info] = "We can not find your billing information, please contact customer service."
      false
    end
  end
end