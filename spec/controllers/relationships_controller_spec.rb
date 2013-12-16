require 'spec_helper'

describe RelationshipsController do 
  describe 'GET #index' do 
    it_behaves_like 'require_sign_in' do 
      let(:action) { get :index }
    end

    it "render 'relationships/index'template" do 
      set_current_user
      get :index
      expect(response).to render_template 'relationships/index'
    end

    it "sets @relationships to current_user's relationships" do 
      set_current_user
      follower = @user
      leader = create(:user)
      friendships = Fabricate(:relationship, follower: follower, leader: leader)
      get :index
      expect(assigns(:relationships)).to eq([friendships])
    end
  end

  describe 'DELETE #destroy' do 
    it_behaves_like 'require_sign_in' do 
      let(:action) { delete :destroy, id: Faker::Number.digit }
    end

    it 'delete  the relationship if the current_user is the follower' do 
      set_current_user
      follower = @user
      leader = create(:user)
      friendships = Fabricate(:relationship, follower: follower, leader: leader)
      expect{ delete :destroy, id: friendships }.to change(Relationship, :count).by(-1) 
    end

    it 'does not delete the relationship if the current_user is not the follower' do 
      set_current_user
      follower = create(:user)
      leader = create(:user)
      friendships = Fabricate(:relationship, follower: follower, leader: leader)
      expect{ delete :destroy, id: friendships }.to change(Relationship, :count).by(0) 
    end 

    it 'redirect to people page' do 
      set_current_user
      follower = @user
      leader = create(:user)
      friendships = Fabricate(:relationship, follower: follower, leader: leader)
      delete :destroy, id: friendships
      expect(response).to redirect_to people_path
    end
  end

  describe 'POST #create' do 
    it_behaves_like 'require_sign_in' do 
      let(:action) { post :create, leader_id: 3}
    end

    it 'creates the relationship that current user follows the leader' do 
      set_current_user
      leader = create(:user)
      post :create, leader_id: leader
      expect(@user.following_relationships.last.leader).to eq(leader)
    end

    it 'redirect_to people_path' do
      set_current_user
      leader = create(:user) 
      post :create, leader_id: leader
      expect(response).to redirect_to people_path
    end

    it 'does not create the relationship if current user already follow the leader' do 
      set_current_user
      leader = create(:user)
      relationship = Fabricate(:relationship, follower: @user, leader: leader)
      expect{ post :create, leader_id: leader }.not_to change(Relationship, :count)
      expect(flash[:error]).not_to be_nil 
    end

    it 'does not follow themselves'do 
      set_current_user
    end
  end
end