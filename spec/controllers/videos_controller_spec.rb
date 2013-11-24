require 'spec_helper'

describe VideosController do 
  context 'have singed in' do
    let(:response_expect) do 
      expect(response)
    end

    before :each do 
      @video = create(:video)
      session[:user_id] = create(:user)
    end 

    describe 'GET videos#index' do  
      it 'sets @videos, @categories' do 
        fab = Fabricate(:video) 
        get :index
        expect(assigns(:videos)).to eq(Video.all)
        expect(assigns(:categories)).to eq(Category.all)
      end
  
      it 'render template videos/index' do 
        get :index
        response_expect.to render_template :index
      end
    end

    describe 'GET videos#show' do 
      it 'sets @video' do
        get :show, id: @video
        expect(assigns(:video)).to eq(Video.find(@video)) 
      end

      it 'render_template videos/show' do
        get :show, id: @video
        response_expect.to render_template :video_show
      end
    end

    describe 'POST videos#search' do 
      let(:search_term) { attributes_for(:search)[:title] }
      
      it 'sets @items' do 
        exist_video = create(:video, title: search_term)
        post :search, search: search_term[0..3]
        expect(assigns(:items)).to eq( { exist_video.category => [exist_video] } )
      end    

      it 'POST videos#search' do
        post :search, search: search_term[0..4]
        response_expect.to render_template :search
      end
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

    it 'POST videos#search' do 
      post :search
      expect(response).to redirect_to :sign_in
    end

  end
end