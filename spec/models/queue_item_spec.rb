require 'spec_helper'

def avg_rating(reviews) 
  total_rate = 0.00
  total_rate = reviews.reduce(total_rate) do |sum, c| 
    sum += c.rating
  end
  unless reviews.blank?
    total_rate /= reviews.count 
    total_rate.round(1)
  end
end

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:position) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:video_id) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }

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
      user_reviews = @video.reviews.where(user: @user)
      expect(@queue_item.rating).to eq(avg_rating(user_reviews))
    end

    it 'returns nil when review does not present' do
      expect(@queue_item.rating).to be_nil
    end
  end 

  describe '#category AND #category_name' do
    before :each do 
      @category = create(:valid_category)
      @video.category = @category
    end

    it 'returns the category name of associated video' do 
      expect(@queue_item.category_name).to eq(@video.category.name)
    end

    it 'returns the category of associated video' do 
      expect(@queue_item.category).to eq(@video.category)
    end
  end
end