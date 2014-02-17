require 'spec_helper'

describe StripeWrapper do 
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
      :number => "4242424242424242",
      :exp_month => 1,
      :exp_year => 2015,
      :cvc => "314"
      }
    ).id
  end

  let(:declined_token) do 
    Stripe::Token.create(
      :card => {
      :number => "4000000000000002",
      :exp_month => 1,
      :exp_year => 2015,
      :cvc => "314"
      }
    ).id
  end 

  describe StripeWrapper::Charge do 
    describe '.create' do
      it "makes a successful charge", :vcr do
        token = valid_token

        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: 'a valid charge' 
        )

        expect(response).to be_successful  
      end

      it "makes a card declined charge", :vcr do 
        token = declined_token
        
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: 'an invalid charge' 
        )

        expect(response).not_to be_successful
      end

      it 'should return flash error message', :vcr do 
        token = declined_token
        
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: 'an invalid charge' 
        )

        expect(response.error_message).to include("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do 
    describe '::create' do 
      it "creates a customer with valid card", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
            user: user,
            card: valid_token
          ) 
        expect(response).to be_successful
      end

      it "does not create a customer with declined card", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
            user: user,
            card: declined_token
          ) 
        expect(response).not_to be_successful
      end

      it "returns error message for declined card charge", :vcr do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
            user: user,
            card: declined_token
          )
        expect(response.error_message).to be_present 
      end

      it "returns a customer token for a valid card", :vcr do
        user = Fabricate.create(:user)
        response = StripeWrapper::Customer.create(
            user: user,
            card: valid_token
          ) 
        expect(response.customer_token).to be_present        
      end
    end

    describe "::retrieve" do
      it "get the list of subscripton data", :vcr do
        user = Fabricate.create(:user)

        response = StripeWrapper::Customer.create(
            user: user,
            card: valid_token
        )

        subscriptions = StripeWrapper::Customer.retrieve(response.customer_token)
        expect(subscriptions.data.first.id).to eq(response.subscription_token) 
      end
    end
  end
end

