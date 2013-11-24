require 'spec_helper'

describe PagesController do

  context 'is a member' do
    before :each do 
      session[:user_id] = create(:user)
    end

    it 'browse pages#front 'do 
      get :front
      expect(response).to redirect_to home_path
    end
  end

  context 'is not a member' do
    before :each do 
      session[:user_id] = nil
    end

    it 'browse pages#front 'do 
      get :front
      expect(response).to render_template :front
    end
  end
end