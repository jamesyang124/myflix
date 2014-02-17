require 'spec_helper'

describe PlansController do 
  describe "GET #index" do 
    it "set @payments for current user", :vcr do
      user = Fabricate(:user, customer_token: "somt_token")
      Payment.create(amount: 999, user: user)
      set_current_user(user)
    
      PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with(user.customer_token).and_return(true)

      get :index
      expect(assigns(:payments)).to match_array(Payment.where(user_id: user))
    end

    it "retrieve a list of subscription history from Stripe", :vcr do
      user = Fabricate(:user, customer_token: "some_token")
      set_current_user(user)

      subscriptions = double(:valid_list)
      subscriptions.stub_chain(:data, :last, :plan, :name).and_return("myflix_base_plan")
      subscriptions.stub_chain(:data, :last, :current_period_end).and_return(1392446068)
      subscriptions.stub_chain(:data, :last, :plan, :amount).and_return(999)

      StripeWrapper::Customer.should_receive(:retrieve).with(user.customer_token).and_return(subscriptions)

      get :index
      expect(assigns(:recent_sub_plan)).to eq("myflix_base_plan")  
      expect(assigns(:recent_sub_period_end)).to eq(Time.at(1392446068).strftime("%m/%d/%Y"))
      expect(assigns(:recent_sub_amount)).to eq(9.99)       
    end

    it "render plans/index template", :vcr do
      user = Fabricate(:user, customer_token: "some_token")
      set_current_user(user)
      Payment.create(amount: 999, user: user)

      PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with(user.customer_token).and_return(true)

      get :index
      expect(response).to render_template :index
    end

    it "redirect to root_path if customer_token is nil or cannot find data from stripe", :vcr do
      user = Fabricate(:user, customer_token: "wrong")
      set_current_user(user)
      Payment.create(amount: 999, user: user)

      PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with(user.customer_token).and_return(false)

      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "POST #create" do
    
  end
end