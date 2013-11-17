require 'spec_helper'

describe CategoriesController do 
  context 'have signed in' do 
    before :each do 
      session[:user_id] = User.first.id
      @category = create(:category)
    end

    it 'GET categories#show' do 
      get :show, id: @category
      expect(assigns(:category)).to eq(@category) 
    end
  end

  context 'have not signed in' do 
    before :each do 
      session[:user_id] = nil
      @category = create(:category)
    end

    it 'GET categories#show' do 
      get :show, id: @category
      expect(response).to redirect_to sign_in_path 
    end
  end
end