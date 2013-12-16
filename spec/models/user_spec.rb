require 'spec_helper'

describe User do 
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_secure_password }
  it { should have_many(:queue_items).order("position ASC") }

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
end