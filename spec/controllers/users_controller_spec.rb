require 'spec_helper'
require 'faker'

describe UsersController do 
  context 'GET User#new' do 
    it 'has new User model object' do 
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'render the users#new template' do 
      get :new
      expect(response).to render_template 'users/new'
    end
  end

  context 'POST User#create' do
    describe 'save failed with invalid personal info then' do 
      before :each do 
        Stripe::Charge.stub(:create)
      end

      let(:invalid_name_post) { post :create, user: attributes_for(:invalid_name) }
      let(:invalid_email_post) { post :create, user: attributes_for(:invalid_email) }
      let(:invalid_password_post) { post :create, user: attributes_for(:invalid_password) }

      it 'render template users/new when full name is nil' do
        expect{ invalid_name_post }.to_not change(User, :count) 
        expect(response).to render_template :new
      end
  
      it 'render template users/new when email is nil' do
        expect{ invalid_email_post }.to_not change(User, :count)
        expect(response).to render_template :new 
      end
  
      it 'render template users/new when password is nil' do
        expect{ invalid_password_post }.to_not change(User, :count) 
        expect(response).to render_template :new
      end

      it 'render template users/new when password is less than 9 characters' do
        expect{
          post :create, user: attributes_for(:user, password: Faker::Lorem.characters(8))
        }.to_not change(User, :count) 
        expect(response).to render_template :new
      end

      it 'should not charge credit card' do
        invalid_email_post
        StripeWrapper::Charge.should_not_receive(:create)
      end
    end

    describe 'save failed with valid personal info and decliend credit card' do 
      let(:valid_post) { post :create, user: attributes_for(:user), stripeToken: "1231241" }


      it 'does not create a new user' do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        valid_post 

        expect(User.count).to eq(0)
      end

      it "renders :new template" do 
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        valid_post 

        expect(response).to render_template :new      
      end

      it 'set @user' do 
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        valid_post

        expect(assigns(:user)).to be_present 
      end

      it 'sets flash error message' do 
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        valid_post

        expect(flash.now[:error]).to be_present 
      end
    end

    describe 'save successful with valid personal and card information then' do 
      let(:valid_post) { post :create, user: attributes_for(:user)}
      after { ActionMailer::Base.deliveries.clear }
      before :each do 
        charge = double(:charge, successful?: true)
        Stripe::Charge.should_receive(:create).and_return(charge)
      end

      it 'store valid data' do
        expect{ valid_post }.to change(User, :count).by(1) 
      end

      it 'redirect to root_path' do
        valid_post
        expect(response).to redirect_to root_path
      end

      it 'makes the user follows the inviter' do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: inviter.id)
        user = attributes_for(:user, email: invitation.recipient_email, full_name: invitation.recipient_name) 

        post :create, user: user, invitation_token: invitation.token

        expect(assigns(:user).follows?(inviter)).to be_true
      end

      it 'makes the inviter follows the user' do 
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: inviter.id)
        user = attributes_for(:user, email: invitation.recipient_email, full_name: invitation.recipient_name) 

        post :create, user: user, invitation_token: invitation.token
        expect(inviter.follows?(assigns(:user))).to be_true

      end

      it 'expired the invitation upon acceptance' do 
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: inviter.id)
        user = attributes_for(:user, email: invitation.recipient_email, full_name: invitation.recipient_name) 

        post :create, user: user, invitation_token: invitation.token
        expect(Invitation.find_by(token: invitation.token)).to be_nil
      end
    end

    context 'sending emails' do 
      before(:each) do
        charge = double(:charge, successful?: true)
        Stripe::Charge.stub(:create).and_return(charge)
      end

      after { ActionMailer::Base.deliveries.clear }
      
      it 'sends out the email to the user with valid inputs' do 
        post :create, user: {email: "none@email.com", password: "123456789", full_name: "None test"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['none@email.com'])
      end
      it "sends out the email containing the user's name with valid inputs" do 
        post :create, user: {email: "none@email.com", password: "123456789", full_name: "None test"}
        expect(ActionMailer::Base.deliveries.last.body).to include("None test")
      end

      it 'does not send out the email with invalid input' do 
        post :create, user: { email: "noneemail.com", password: nil, full_name: nil }
        expect(ActionMailer::Base.deliveries).to be_blank
      end
    end
  end

  describe 'GET #show' do 
    it_behaves_like "require_sign_in" do 
      user = Fabricate.create(:user)
      let(:action) { get :show, id: user.id }
    end

    it "sets @user" do 
      set_current_user
      get :show, id: @user
      expect(assigns(:user)).to eq(@user)
    end

    it 'render /users/show template' do
      set_current_user 
      get :show, id: @user
      expect(response).to render_template 'users/show'
    end 
  end 

  describe "GET #new_with_invitation_token" do
    it 'renders :new view template' do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email) 
    end

    it 'sets @invitation_token' do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it 'redirects to expired token page for invalid token' do
      get :new_with_invitation_token, token: "invalid token"
      expect(response).to redirect_to expired_token_path
    end

  end
end