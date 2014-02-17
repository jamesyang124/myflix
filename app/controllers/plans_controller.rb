class PlansController < ApplicationController 
  before_action :require_user

  def index
    @payments = Payment.where(user_id: current_user)
    if @subscriptions = StripeWrapper::Customer.retrieve(current_user.customer_token)
       @recent_sub_plan = @subscriptions.data.last.plan.name
       @recent_sub_period_end = Time.at(@subscriptions.data.last.current_period_start).strftime("%m/%d/%Y")
       @recent_sub_amount = @subscriptions.data.last.plan.amount/100.0
    else
       redirect_to root_path
    end
  end

  def create
    
  end
end