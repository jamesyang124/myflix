require 'spec_helper'

describe ReviewsController do 
  describe 'POST create' do 
    before :each  do 
      @video = create(:video)
      @current_user = create(:user)
    end

    describe 'post by authenticated user' do
      before :each do 
        session[:user_id] = @current_user.id
      end
      
      context 'submit valid reviews' do 
        before :each do
          post :create, video_id: @video, review: attributes_for(:review)
        end

        it 'associate @review to video' do 
          expect(Review.last.video).to eq(@video) 
        end

        it 'associate @review to a signed-in user' do 
          expect(Review.last.user).to eq(@current_user) 
        end

        it 'redirect to current video page'do
          expect(response).to redirect_to @video
        end
      end

      context 'submit invalid reviews' do
        before :each do
          @count = Review.count
          post :create, video_id: @video, review: {rating: 4}
        end

        it 'save review failed' do 
          expect(Review.count).to eq(@count) 
        end

        it 'set flash.now error message' do 
          expect(flash.now[:error]).not_to be_blank
        end

        it 'set @video to render template' do 
          expect(assigns(:video)).to eq(@video)
        end

        it 'render current page' do 
          expect(response).to render_template 'videos/video_show'
        end
      end
    end

    describe 'post reviews by un-authenticated user' do 
      before :each do 
        session[:user_id] = nil
        post :create, video_id: @video, review: attributes_for(:review)
      end

      it 'set flash[:info] message' do
        expect(flash[:info]).not_to be_blank 
      end 

      it 'redirect to root_path' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end