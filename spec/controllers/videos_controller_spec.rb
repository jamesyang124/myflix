require 'spec_helper'

describe VideosController do 
  context 'have singed in' do
    let(:response_expect) do 
      expect(response)
    end

    before :each do 
      @video = create(:video)
      set_current_user
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

      it 'sets reviews' do
        5.times { @video.reviews << create(:review) }

        get :show, id: @video
        expect(assigns(:video).reviews).to match_array @video.reviews
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
    context 'GET videos#index' do
      it_behaves_like 'require_sign_in' do 
        let(:action) { get :index }
      end
    end

    context 'GET videos#show' do 
      it_behaves_like 'require_sign_in' do 
        let(:action) { get :show, id: create(:video) }
      end   
    end

    context 'POST videos#search' do 
      it_behaves_like 'require_sign_in' do 
        let(:action) { post :search }
      end
    end
  end
end