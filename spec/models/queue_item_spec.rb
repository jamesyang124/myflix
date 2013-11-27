require 'spec_helper'

describe QueueItem do 
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:position) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:user) }

  before :each do 
    @video = create(:video)
    @user = create(:registered_user)
    @queue_item = create(:queue_item, video: @video, user: @user)
  end
  
  describe '#video_title ' do 
    it 'returns the title of associated video' do 
      expect(@queue_item.video_title).to eq(@video.title)
    end
  end

  describe '#rating' do 
    it 'returns the rating of associated video when review present' do
      review = create(:review, user: @user)
      @video.reviews << review
      expect(@queue_item.rating).to eq(@video.reviews_total_rate)
    end

    it 'returns nil when review does not present' do
      expect(@queue_item.rating).to be_nil
    end
  end 
end