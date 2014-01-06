require 'spec_helper'

describe User do 
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_secure_password }
  it { should have_many(:queue_items).order("position ASC") }

  it_behaves_like "tokenable" do 
    let(:object) { Fabricate(:user) }
  end

  describe '#queued_video?' do 
    it 'return true when user has queued video' do 
      user = create(:user)
      video = create(:video)
      create(:queue_item, video: video, user: user)
      expect(user.queued_video?(video)).to be_true
    end

    it 'return false when user has not queued video' do 
      user = create(:user)
      video = create(:video)
      create(:queue_item, video: create(:video), user: user)
      expect(user.queued_video?(video)).to be_false
    end
  end

  describe '#follows?' do 
    it 'return true if the user has followed another user 'do 
      follower = create(:user)
      leader = create(:user)
      relationship = Fabricate(:relationship, follower: follower, leader: leader)
      expect(follower.follows?(leader)).to be_true
    end

    it 'return false if the user have not followed another user' do 
      follower = create(:user)
      leader = create(:user)
      expect(follower.follows?(leader)).to be_false
    end

    it 'return false if the user followed themselves' do 
      follower = create(:user)
      expect(follower.follows?(follower)).to be_false
    end
  end

  describe "#follow" do
    it "return a new relationship that follows another user" do
      follower = create(:user)
      leader = create(:user)
      expect(follower.follow(leader)).to be_instance_of(Relationship)
      expect(follower.follows?(leader)).to be_true
    end

    it 'returns nil if anothr user not exist' do 
      follower = create(:user)
      expect(follower.follow(nil)).to be_nil
    end 

    it 'returns nil if it has existed in relationships table' do 
      follower = create(:user)
      leader = create(:user)
      relationship = follower.follow(leader)
      relationship_again = follower.follow(leader)

      expect(relationship_again).to be_nil
    end

    it 'returns nil if another user is self' do 
      follower = create(:user)
      leader = follower
      expect(follower.follow(leader)).to be_nil
    end
  end
end