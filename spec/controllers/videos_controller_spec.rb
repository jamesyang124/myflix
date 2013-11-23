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
    it 'GET videos#index' do 
      fab = Fabricate(:video) 
      get :index
      expect(assigns(:videos)).to eq(Video.all)
      expect(assigns(:categories)).to eq(Category.all)
      response_expect.to render_template :index
    end

    it 'GET videos#show' do 
      get :show, id: @video
      expect(assigns(:video)).to eq(Video.find(@video)) 
      response_expect.to render_template :video_show
    end

    it 'POST videos#search' do 
      search_term = attributes_for(:search)[:title]
      post :search, search: search_term
      expect(assigns(:items)).to eq(Video.search_by_title_categorized(search_term))
      response_expect.to render_template :search
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