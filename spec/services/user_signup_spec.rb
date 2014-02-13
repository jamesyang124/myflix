require 'spec_helper'

describe UserSignup do 
  describe "#sign_up" do 
    context 'save successful with valid personal and card information then' do
      let(:valid_post) { post :create, user: attributes_for(:user)}
      
      after { ActionMailer::Base.deliveries.clear }
      
      before :each do 
        customer = double(:subscription_charge, successful?: true)
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end

      it 'store valid data' do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1) 
      end

      it 'makes the user follows the inviter' do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: inviter.id)
        user = attributes_for(:user, email: invitation.recipient_email, full_name: invitation.recipient_name) 

        UserSignup.new(Fabricate.build(:user, email: user[:email], full_name: user[:full_name], password: "123456789")).sign_up("some_stripe_token", invitation.token)

        recipient =  User.where(email: user[:email]).first
        expect(recipient.follows?(inviter)).to be_true
      end

      it 'makes the inviter follows the user' do 
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: inviter.id)
        user = attributes_for(:user, email: invitation.recipient_email, full_name: invitation.recipient_name) 

        UserSignup.new(Fabricate.build(:user, email: user[:email], full_name: user[:full_name], password: "123456789")).sign_up("some_stripe_token", invitation.token)

        recipient =  User.where(email: user[:email]).first
        expect(inviter.follows?(recipient)).to be_true

      end

      it 'expired the invitation upon acceptance' do 
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: inviter.id)
        user = attributes_for(:user, email: invitation.recipient_email, full_name: invitation.recipient_name) 

        UserSignup.new(Fabricate.build(:user, email: user[:email], full_name: user[:full_name], password: "123456789")).sign_up("some_stripe_token", invitation.token)

        expect(Invitation.find_by(token: invitation.token)).to be_nil
      end

      it 'sends out the email to the user with valid inputs' do
        user = attributes_for(:user) 
        UserSignup.new(Fabricate.build(:user, email: user[:email], full_name: user[:full_name], password: "123456789")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq([user[:email]])
      end

      it "sends out the email containing the user's name with valid inputs" do 
        user = attributes_for(:user) 
        UserSignup.new(Fabricate.build(:user, email: user[:email], full_name: user[:full_name], password: "123456789")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include(user[:full_name])
      end
    end

    describe "save failed with valid personal info and decliend credit card" do 
      it 'does not create a new user' do        
        customer = double(:subscription_charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
              
        expect(User.count).to eq(0)
      end
    end

    context 'save failed with invalid personal info then' do 
      after { ActionMailer::Base.deliveries.clear }

      it 'does not create user' do 
        user = attributes_for(:user) 
        UserSignup.new(Fabricate.build(:user, email: nil, full_name: user[:full_name], password: "123456789")).sign_up("some_stripe_token", nil)        
        expect(User.count).to eq(0)
      end

      it 'should not charge credit card' do
        StripeWrapper::Customer.should_not_receive(:create)
        user = attributes_for(:user) 
        UserSignup.new(Fabricate.build(:user, email: nil, full_name: user[:full_name], password: "123456789")).sign_up("some_stripe_token", nil)
      end

      it 'does not send out the email with invalid input' do 
        user = attributes_for(:user) 
        UserSignup.new(Fabricate.build(:user, email: user[:email], full_name: nil, password: nil)).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries).to be_blank
      end
    end
  end
end