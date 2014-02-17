class PlansController < ApplicationController 
  before_action :require_user

  def index
    @payments = Payment.where(user_id: current_user)
    @subscriptions = StripeWrapper::Customer.retrieve(current_user.customer_token)
  end

  def create
    
  end
end