require 'spec_helper'

describe UsersController do 
  context 'GET User#new' do 
    it 'has new User model object' do 
      fake_user = create(:user)

      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'render the users#new template' do 
      get :new
      expect(response).to render_template 'users/new'
    end
  end

  context 'POST User#create' do 
    it 'Save failed when full name is nil' do
      expect{
        post :create,
          user: attributes_for(:invalid_name)  
      }.to_not change(User, :count) 
    end

    it 'Save failed when email is nil' do
      expect{
        post :create,
          user: attributes_for(:invalid_email)  
      }.to_not change(User, :count) 
    end

    it 'Save failed when password is nil' do
      expect{
        post :create,
          user: attributes_for(:invalid_password)  
      }.to_not change(User, :count) 
    end

    it 'Save failed when password is less than 9 characters' do
      expect{
        post :create,
          user: attributes_for(:user, password: '12345678')  
      }.to_not change(User, :count) 
    end

    it 'Save succesfull when all valid data' do
      expect{
        post :create,
          user: attributes_for(:user)  
      }.to change(User, :count).by(1) 
    end
  end
end