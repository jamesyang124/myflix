require 'spec_helper'

describe QueueItemsController do 
  context 'authenticated user' do 
    before :each do 
      user = create(:registered_user)
      session[:user_id] = user.id
      @q_item_1 = create(:queue_item, video_id: create(:video).id, user_id: user.id)
      @q_item_2 = create(:queue_item, video_id: create(:video).id, user_id: user.id)
       
      get :index

    end

    describe 'GET queue_items#index' do 
      it 'set @queue_items by current user' do 
        expect(assigns(:queue_items)).to match_array([@q_item_1, @q_item_2])
      end
      it 'render template queue_items/index' do 
        expect(response).to render_template :index
      end
    end
  end
  
  context 'un-authenticated user' do 
    before :each do 
      session[:user_id] = nil
    end

    describe 'GET queue_items#index' do
      it 'set flash info message' do 
        get :index
        expect(flash[:info]).not_to be_blank 
      end

      it 'redirect to sign_in path' do 
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end

end