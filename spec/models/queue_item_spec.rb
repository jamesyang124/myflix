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
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:position) }
  it { should validate_presence_of(:video_id) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
  it { should validate_numericality_of(:position).only_integer }

  before :each do 
    set_new_queue_item_instance
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
      expect(@queue_item.reload.rating).to be_nil
    end
  end 

  describe "#rating=" do 
    it 'update the rating values for last review if reviews present' do 
      review = create(:review, user: @user, video: @video, rating: 2)
      @queue_item.rating = 4
      expect(@queue_item.reload.rating).to eq(4)
    end

    it 'clear the rating for last review if reviews present' do 
      review = create(:review, user: @user, video: @video, rating: 2)
      @queue_item.rating = nil
      expect(@queue_item.reload.rating).to be_nil
    end

    it 'create the rating if reviews do not present' do 
      @queue_item.rating = 5
      expect(@queue_item.reload.rating).to eq(5)
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