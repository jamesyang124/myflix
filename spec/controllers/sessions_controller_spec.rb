require 'spec_helper'

describe SessionsController do 
  
  context 'GET sessions#new' do 
    it 'render sessions/edit template for un-aunthenticated userr'do 
      get :new
      expect(response).to render_template :new
    end

    it do 'redirect to home_path for authenticated user'
      session[:user_id] = create(:registered_user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  context 'POST sessions#create' do
    before :each do 
      @user = create(:registered_user)
    end

    describe 'with valid credentials' do
      before :each do 
        post :create, email: @user.email, password: @user.password
      end

      it 'sets @user' do 
        expect(assigns(:user)).to eq(@user)
      end

      it 'set session id to current user' do 
        expect(session[:user_id]).to eq(@user.id)
      end

      it 'set flash notice message' do
        expect(flash[:notice]).not_to be_blank
      end

      it 'redirect to videos#home' do 
        expect(response).to redirect_to home_path
      end
    end

    describe 'with invalid credentials' do
      before :each do 
        post :create, email: @user.email, password: @user.password << "--"
      end

      it 'do not set session id to current user' do
        expect(session[:user_id]).to be_nil
      end

      it 'set flash.now error mesage' do 
        expect(flash[:notice]).to be_blank
        expect(flash.now[:info]).not_to be_blank
      end

      it 'render to /sessions/new' do 
        expect(response).to render_template :new
      end
    end
  end

  context "GET sessions#destroy" do 
    before :each do 
      session[:user_id] = create(:registered_user).id
      get :destroy
    end

    it 'clean session id to nil' do 
      expect(session[:user_id]).to be_nil
    end
    it 'set falsh notice' do 
      expect(flash[:notice]).not_to be_blank 
    end
    it 'redirect to root_path' do 
      expect(response).to redirect_to root_path
    end
  end
end