require 'spec_helper'

describe VideosController do 
  context 'have singed in' do
    before :each do 
      @video = create(:video)
      session[:user_id] = create(:user)
    end 
    it 'GET videos#index' do 
      get :index
      expect(assigns(:videos)).to eq(Video.all)
      expect(assigns(:categories)).to eq(Category.all)
      expect(response).to render_template :index
    end

    it 'GET videos#show' do 
      get :show, id: @video
      expect(assigns(:video)).to eq(Video.find(@video)) 
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
      @video = create(:video)
      session[:user_id] = nil
    end

    it 'GET videos#index' do 
      get :index
      expect(response).to redirect_to :sign_in
    end

    it 'GET videos#show' do 
      get :show, id: @video
      expect(response).to redirect_to :sign_in
    end

    it 'GET videos#search' do 
      get :search
      expect(response).to redirect_to :sign_in
    end

    it 'GET videos#front' do 
      get :front
       expect(response).to render_template :front
    end
  end
end