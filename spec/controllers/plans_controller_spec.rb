require 'spec_helper'

describe PlansController do 
  describe "GET #index" do 
        
    it "set @payments for current user", :vcr do
      user = Fabricate(:user, customer_token: "some_token")
      set_current_user(user)
      
      subscriptions = double(:list_subscriptions_data)
      StripeWrapper::Customer.should_receive(:retrieve).and_return(subscriptions)

      get :index
      expect(assigns(:payments)).to match_array(Payment.where(id: user))
    end

    it "retrieve a list of subscription history from Stripe", :vcr do
      user = Fabricate(:user, customer_token: "some_token")
      set_current_user(user)

      subscriptions = double(:list_subscriptions_data)
      StripeWrapper::Customer.should_receive(:retrieve).and_return(subscriptions)

      get :index
      expect(assigns(:subscriptions)).to be_present       
    end

    it "render plans/index template", :vcr do
      user = Fabricate(:user, customer_token: "some_token")
      set_current_user(user)
      Payment.create(amount: 999, user: user)

      subscriptions = double(:list_subscriptions_data)
      StripeWrapper::Customer.should_receive(:retrieve).and_return(subscriptions)

      get :index
      expect(response).to render_template :index
    end
  end

  describe "POST #create" do
    
  end
end