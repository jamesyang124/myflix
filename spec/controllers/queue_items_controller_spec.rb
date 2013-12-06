require 'spec_helper'

describe QueueItemsController do 
  context 'authenticated user' do 
    before :each do 
      @user = create(:registered_user)
      session[:user_id] = @user.id
      video_1 = create(:video)
      video_2 = create(:video)
      @q_item_1 = create(:queue_item, video: video_1, user_id: @user.id, position: 1)
      @q_item_2 = create(:queue_item, video: video_2, user_id: @user.id, position: 2)
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

    describe 'POST queue_items#create' do
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

    describe 'DELETE queue_items#destroy' do
      before :each do
        video = create(:video) 
        @q = create(:queue_item, video: video, user: @user, position: @user.queue_items.sample.position)
      end

      it 'redirect to queue_items/my_queue page' do 
        delete :destroy, id: @q
        expect(response).to redirect_to queue_items_path
      end
  
      it 'remove selected queue item' do 
        expect{
          delete :destroy, id: @q
        }.to change(QueueItem, :count).by(-1)
      end

      it "does not remove queue item which is not in current user's queue" do
        q = create(:queue_item, video: create(:video), user: create(:user), position: @user.queue_items.sample.position) 
        expect{
          delete :destroy, id: q
        }.not_to change(QueueItem, :count) 
      end

      it 'normailize the position' do
        new_item = create(:queue_item, video: create(:video), user: @user, position: QueueItem.count + 1)
        delete :destroy, id: @q
        expect(new_item.reload.position).to eq(@user.queue_items.count)
      end

      it 'raise exception when DELETE without params[:id]' do 
        expect{
          delete :destroy
        }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    describe 'POST update_queue' do
      context 'input valid position' do 
        let(:valid_post) do 
          post :update_queue, queue_items: [{id: @q_item_2.id, position: @q_item_2.position}, {id: @q_item_1.id, position: @q_item_1.position}] 
        end
        it 'reorder the q items' do
          valid_post
          expect(@user.reload.queue_items).to eq([@q_item_1, @q_item_2])
          expect(@user.reload.queue_items).not_to eq([@q_item_2, @q_item_1])
        end

        it 'normailize the position order' do
          @q_item_1.position = 2
          @q_item_2.position = 3 
          valid_post
          expect(@user.reload.queue_items.map(&:position)).to eq([1, 2])
          expect(@q_item_2.reload.position).to eq(2)
        end

        it 'redirect to queue_items_path' do
          valid_post 
          expect(response).to redirect_to queue_items_path
        end
      end

      context 'input invalid position' do 
        before :each do 
          @q2_invalid_pos = 3.4
          @q1_valid_pos = 5
        end

        let(:invalid_post) do
           post :update_queue, queue_items: [{id: @q_item_1.id, position: @q1_valid_pos}, {id: @q_item_2.id, position: @q2_invalid_pos}]
        end

        it 'redirect to queue_items_path without update' do 
          invalid_post
          expect(response).to redirect_to queue_items_path
        end

        it 'unchange all queue items' do 
          expect{ invalid_post }.not_to change(QueueItem, :count)
          invalid_post
          expect(@q_item_1.reload.position).to eq(1)
          expect(@q_item_2.reload.position).to eq(2)
        end

        it 'flash error message' do 
          invalid_post
          expect(flash[:error]).not_to be_blank
        end
      end

      it 'update a queue items not belongs to current user' do 
        q2_valid_pos = 3
        q1_valid_pos = 5
        @q_item_2.update_attributes(user: create(:user))
        post :update_queue, queue_items: [{id: @q_item_1.id, position: q1_valid_pos}, {id: @q_item_2.id, position: q2_valid_pos}]
        expect(@q_item_1.reload.position).not_to eq(q1_valid_pos)
        expect(@q_item_2.reload.position).not_to eq(q2_valid_pos)
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

    describe 'DELETE queue_items#destroy' do 
      it 'redirect to sign in path' do 
        q = create(:queue_item, video: create(:video), user: create(:user), position: 1)
        delete :destroy, id: q
        expect(response).to redirect_to sign_in_path
      end
    end

    describe 'POST update_queue' do
      it 'redirect to sign_in_path' do 
        post :update_queue, queue_items: [{id:1, position:2}]
        expect(response).to redirect_to sign_in_path
      end
    end

  end
end