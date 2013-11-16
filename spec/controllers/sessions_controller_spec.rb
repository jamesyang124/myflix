require 'spec_helper'

describe SessionsController do 
  
  context 'GET session#new' do 
    it 'render sessions/edit template'do 
      get :edit
      expect(response).to render_template :edit
    end
  end

  context 'POST session#create' do
    before :each do 
      @user = create(:registered_user)
    end

    it 'redirect to videos#home if authenticate successed' do 
      post :create, email: @user.email, password: @user.password
      expect(response).to redirect_to home_path
    end

    it 'render to /sessions/edit if password wrong' do 
      post :create, email: @user.email, password: '123456789'
      expect(response).to render_template :edit
    end

    it 'render to sessions/edit if email wrong' do 
      post :create, email: 'wrong@example.com', password: @user.password
      expect(response).to render_template :edit
    end
  end
end