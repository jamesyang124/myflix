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
  end
end