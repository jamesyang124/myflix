require 'spec_helper'

describe PlansController do
  # set a memoized method for returning subscriptions test double
  let(:subscriptions) do 
    subscriptions = double(:valid_list)
    subscriptions.stub_chain(:amount).and_return(999)
    subscriptions
  end


  describe "GET #index" do 
    it "set @payments for current user", :vcr do
      user = Fabricate(:user, customer_token: "some_token")
      Payment.create(amount: 999, user: user, end_date: 1392446068)
      set_current_user(user)
    
      PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with(user.customer_token).and_return(true)

      get :index
      expect(assigns(:payments)).to match_array(Payment.where(user_id: user))
    end

    it "retrieve a list of subscription history from Stripe", :vcr do
      user = Fabricate(:user, customer_token: "some_token")
      set_current_user(user)
      Payment.create(amount: 999, user: user, end_date: 1392446068)

      #StripeWrapper::Customer.should_receive(:retrieve).with(user.customer_token).and_return(subscriptions)

      get :index
      expect(assigns(:recent_sub_plan)).to eq("Myflix_base_plan")  
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

    it "should assigns @user", :vcr do
      user = Fabricate(:user, customer_token: "123454321")
      set_current_user(user)

      result = double(:mock_result, successful?: true, status_message: "thanks for your payment")
      
      # mock UserSignup's behavior only, do not create real object then set message expectation.
      # UserSignup.any_instance.should_receive(:sign_up).with("stripe_token", nil) => ok
      # UserSignup.new(user).should_receive(:sign_up).with("stripe_token", nil)    => failed

      expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

      post :create, stripeToken: "stripe_token"
      expect(assigns(:user)).to eq(user)
    end

    context "when subscription successed" do
      it "sets flash success message" do
        user = Fabricate(:user, customer_token: "123454321")
        set_current_user(user)

        result = double(:mock_result, successful?: true, status_message: "thanks for your payment")
        expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

        post :create, stripeToken: "stripe_token"
        expect(flash[:success]).to eq("thanks for your payment")
      end

      it "redirect to plans_path when subscription successed" do
        user = Fabricate(:user, customer_token: "123454321")
        set_current_user(user)

        result = double(:mock_result, successful?: true, status_message: "thanks for your payment")
        expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

        post :create, stripeToken: "stripe_token"
        expect(response).to redirect_to home_path
      end

    end
    
    context "when subscription failed" do
      it "should render index view template", :vcr do
        user = Fabricate(:user, customer_token: "123454321")
        set_current_user(user)

        result = double(:mock_result, successful?: false, status_message: "failed to receive your payment")
        expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

        PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with("123454321").and_return(true)

        post :create, stripeToken: "stripe_token"
        expect(response).to render_template :index        
      end

      it "assigns @payments and related instance variable for filling view template" do
        user = Fabricate(:user, customer_token: "123454321")
        set_current_user(user)

        result = double(:mock_result, successful?: false, status_message: "failed to receive your payment")
        expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

        PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with("123454321").and_return(true)

        post :create, stripeToken: "stripe_token"
        expect(assigns(:payments)).to eq(Payment.where(user_id: user))         
      end

      context 'retrieve billing information failed' do 
        it 'sets flash info message', :vcr do 
          user = Fabricate(:user, customer_token: "123454321")
          set_current_user(user)

          result = double(:mock_result, successful?: false, status_message: "failed to receive your payment")
          expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

          PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with("123454321").and_return(false)
  
          post :create, stripeToken: "stripe_token"
          expect(flash[:info]).to eq("We can not find your billing information, please contact customer service.")        

        end

        it "redirect to root_path", :vcr do 
          user = Fabricate(:user, customer_token: "123454321")
          set_current_user(user)
  
          result = double(:mock_result, successful?: false, status_message: "failed to receive your payment")
          expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

          PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with("123454321").and_return(false)

          post :create, stripeToken: "stripe_token"
          expect(response).to redirect_to root_path 
        end
      end

      it "sets flash error message", :vcr do
        user = Fabricate(:user, customer_token: "123454321")
        set_current_user(user)

        result = double(:mock_result, successful?: false, status_message: "failed to receive your payment")
        expect_any_instance_of(UserSignup).to receive(:recharge).with("stripe_token").and_return(result)

        PlansController.any_instance.should_receive(:retrieve_stripe_subscriptions).with("123454321").and_return(true)

        post :create, stripeToken: "stripe_token"
        expect(flash[:error]).to eq("failed to receive your payment")        
      end
    end
  end

  describe "DELETE #destroy" do 
    
    it 'should redirect_to home_path', :vcr do 
      user = Fabricate(:user, customer_token: "customer_token")
      set_current_user user
      Payment.create(amount: 999, user: user)

      customer = double(:customer)
      customer.stub_chain(:subscriptions, :retrieve, :delete) 
      Stripe::Customer.should_receive(:retrieve).with("customer_token").and_return(customer)

      stripe_wrapper_double = double(:stripe_wrapper_double)
      stripe_wrapper_double.stub_chain(:data, :last, :id)
      StripeWrapper::Customer.should_receive(:retrieve).with("customer_token").and_return(stripe_wrapper_double)

      delete :destroy
      expect(response).to redirect_to home_path
    end
  end
end