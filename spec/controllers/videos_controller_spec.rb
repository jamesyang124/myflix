require 'sepc_helper'

describe VideosController do 
  context 'have singed in' do
    before :each do 
      seesion[:user_id] = User.first
    end 
    it 'GET videos#index' do 
      get :index
      expect(response).to render_template :index
    end

    it 'GET videos#show' do 
      get :show
      expect(response).to render_template :video_show
    end

    it 'GET videos#search' do 
      get :search
      expect(response).to render_template :search
    end

    it 'GET videos#front' do 
      get :front
       expect(response).to redirect_to home_path
    end
  end

  context 'have not singed in' do 
    before :each do 
      seesion[:user_id] = nil
    end
  end
end