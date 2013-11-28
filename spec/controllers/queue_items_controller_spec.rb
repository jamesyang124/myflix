require 'spec_helper'

describe QueueItemsController do 
  context 'authenticated user' do 
    before :each do 
      @user = create(:registered_user)
      session[:user_id] = @user.id
      @q_item_1 = create(:queue_item, video_id: create(:video).id, user_id: @user.id)
      @q_item_2 = create(:queue_item, video_id: create(:video).id, user_id: @user.id)
    end

    describe 'GET queue_items#index' do 
      before :each do 
        get :index
      end
      it 'set @queue_items by current user' do 
        expect(assigns(:queue_items)).to match_array([@q_item_1, @q_item_2])
      end
      it 'render template queue_items/index' do 
        expect(response).to render_template :index
      end
    end

    describe 'POST queue_items#crete' do
      before :each do 
        @video = create(:video)
        post :create, video_id: @video.id
      end 

      it 'redirect to queue_items/index' do  
        expect(response).to redirect_to queue_items_path
      end

      it 'set @queue_items associate with current user' do
        expect(assigns(:queue_items).reload).to eq(@user.queue_items)
      end

      it 'send a new post to create another new queue item' do
        video = create(:video)
        expect{
          post :create, video_id: video.id
        }.to change(QueueItem, :count).by(1) 
      end

      it 'put the queue item in last of queue' do 
        expect(assigns(:queue_items).reload.last.video).to eq(@video)
      end

      it 'does not add the video to queue if video alreay in queue' do 
        expect{
          post :create, video_id: @video.id
        }.to change(QueueItem, :count).by(0) 
      end
    end
  end
  
  context 'un-authenticated user' do 
    before :each do 
      session[:user_id] = nil
    end

    describe 'GET queue_items#index' do
      before :each do 
        get :index
      end

      it 'set flash info message' do 
        expect(flash[:info]).not_to be_blank 
      end

      it 'redirect to sign_in path' do 
        expect(response).to redirect_to sign_in_path
      end
    end

    describe 'POST queue_items#crete' do 
      before :each do 
        post :create
      end

      it 'redirect_to sign in path' do 
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end