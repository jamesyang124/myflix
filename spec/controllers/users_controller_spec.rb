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
    describe 'failed sign up and card declined' do 

      after { ActionMailer::Base.deliveries.clear }
      
      let(:valid_post) { post :create, user: attributes_for(:user), stripeToken: "1231241" }
      let(:invalid_name_post) { post :create, user: attributes_for(:invalid_name) }
      let(:invalid_email_post) { post :create, user: attributes_for(:invalid_email) }
      let(:invalid_password_post) { post :create, user: attributes_for(:invalid_password) }

      it "renders :new template" do 
        result = double(:sign_up_result, successful?: false, status_message: "This is error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        valid_post 

        expect(response).to render_template :new      
      end

      it 'set @user' do 
        result = double(:sign_up_result, successful?: false, status_message: "This is error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        valid_post

        expect(assigns(:user)).to be_present 
      end

      it 'sets flash error message' do 
        result = double(:sign_up_result, successful?: false, status_message: "This is error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        valid_post

        expect(flash.now[:error]).to eq("This is error message")
      end


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
    end

    describe 'successful sign up' do 
      it 'redirect to root_path' do
        result = double(:sign_up_result, successful?: true, status_message: "Thank you for your payment for Myflix.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        
        post :create, user: attributes_for(:user) 
        expect(response).to redirect_to root_path
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