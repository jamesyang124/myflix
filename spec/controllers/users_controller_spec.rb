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
    describe 'save failed then' do 
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
    end

    describe 'save successful then' do 
      let(:valid_post) { post :create, user: attributes_for(:user) }
      
      it 'store valid data' do
        expect{ valid_post }.to change(User, :count).by(1) 
      end

      it 'redirect to root_path' do
        valid_post
        expect(response).to redirect_to root_path
      end
    end

    context 'sending emails' do 

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
        post :create, user: {email: "none@email.com"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'GET #show' do 
    it_behaves_like "require_sign_in" do 
      let(:action) { get :show, id: User.first }
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
end