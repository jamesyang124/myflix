require 'spec_helper'

describe ReviewsController do 
  describe 'POST create' do 
    before :each do 
      @review = create(:review)    
    end

    let(:valid_post) { post :create, video_id: @review.video_id, review: attributes_for(:review, rating: @review.rating, content: @review.content, video_id: @review.video_id, user_id: @review.user_id) }
    let(:invalid_post) { post :create, video_id: @review.video_id, review: attributes_for(:review, rating: nil, content: nil, video_id: @review.video_id, user_id: @review.user_id) }

    describe 'post by authenticated user' do
      before :each do 
        session[:user_id] = @review.user_id  
      end 
      
      context 'submit valid reviews' do   
        it 'sets @review to a new instance' do
          valid_post 
          expect(assigns(:review)).to be_an_instance_of(Review)
        end

        it 'save @review successfully' do 
          expect{ valid_post }.to change(Review, :count)
        end

        it 'redirect to current video page'do
          valid_post
          expect(response).to redirect_to video_path(@review.video_id)
        end
      end

      context 'submit invalid reviews' do 
        it 'save @review unsuccessfully' do 
          invalid_post
          expect(assigns(:review).save).to be_false
        end

        it 'render current page' do 
          invalid_post
          expect(flash.now[:error]).not_to be_blank
        end

        it 'render current page' do 
          invalid_post
          expect(response).to render_template 'videos/video_show'
        end
      end 
    end

    describe 'post reviews by un-authenticated user' do 
      before :each do 
        session[:user_id] = nil
      end

      it 'set flash[:info] message' do
        valid_post 
        expect(flash[:info]).not_to be_blank 
      end 

      it 'redirect to root_path' do
        valid_post 
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end