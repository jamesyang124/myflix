require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it 'save itself' do
    video = Video.new(title: 'test', description: 'Good test movie')
    video.save
    expect(Video.find video).to eq(video)

    # should syntax is not suggested.
    # (Video.find video).should == video
    # (Video.find video).should eq(video)
  end

  it 'belongs to category' do
    crime_scene = Category.create(name: 'Crime Scene')
    test_video1 = Video.create(title: 'video1', description: 'desc1', category: crime_scene)
    expect(test_video1.category).to eq(crime_scene)

    should belong_to(:category)
  end

  it 'does not save video without title' do
    current_count = Video.count  
    video = Video.create(description: 'miss title')

    # if save failed, atrributes for model object will be nil.
    expect(video.id).to be_nil 
    expect(Video.count - current_count).to eq(0) 
  end

  it 'does not save video without description' do 
    current_count = Video.count 
    video = Video.create(title: 'miss description')
    expect(video.id).to be_nil
    expect(Video.count - current_count).to eq(0) 
  end

  it 'is valid with title' do
    # videos = Video.all
    # videos.each do |v|
    #   expect(v.title).to_not be_nil
    # end
    should validate_presence_of(:title)
  end

  it 'is valid with description' do
    should validate_presence_of(:description)
  end

  it 'should return empty array when search by whitespace, or empty string' do 
    expect(Video.search_by_title('')).to be_empty
    expect(Video.search_by_title(' ')).to be_empty
  end

  it "should return empty array when search with special query character '_' , '!', or '%'" do 
    expect(Video.search_by_title('%')).to be_empty
    expect(Video.search_by_title('_')).to be_empty
    expect(Video.search_by_title('Inc_ption')).to be_empty
    expect(Video.search_by_title('%ortion')).to be_empty
    expect(Video.search_by_title('Lo!n')).to be_empty
  end

  it 'should return partial matched array when search with exact string' do 
    inception = Video.find_by(title: "Inception")
    lincoln = Video.find_by(title: "Lincoln")
    expect(Video.search_by_title('Inception')).to include(inception)
    expect(Video.search_by_title('Lincoln')).to include(lincoln)
  end

  it 'should return matched array when search with case insensetive string' do 
    crime_scene = Category.create(name: 'Crime Scene')
    Video.create(title: 'video1', description: 'desc1', category: crime_scene)
    expect(Video.search_by_title('I')).to match_array(Video.search_by_title('i'))
  end

  it 'should return matched array with order' do 
    crime_scene = Category.create(name: 'Crime Scene')
    v1 = Video.create(title: 'video1', description: 'desc1', category: crime_scene, created_at: 1.day.ago)
    v2 = Video.create(title: 'video2', description: 'desc2', category: crime_scene)
    expect(Video.search_by_title('video')).to eq([v2,v1])
  end

  context 'has many commments' do 
    let(:reviews) { 6.times { create(:review) } }

    it 'get average rating' do 
      reviews
      video = Video.first
      expect(video.reviews_total_rate).to eq(video.reviews_total_rate) 
    end
  end
end
