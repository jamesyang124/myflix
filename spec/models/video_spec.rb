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
    com = Category.create(name: 'Comedies')
    Video.create(
      title: 'Inception',
      category: com,
      description: "Dom Cobb is a skilled thief, the absolute best in the dangerous art of extraction, stealing valuable secrets from deep within the subconscious during the dream state, when the mind is at its most vulnerable An enemy that only Cobb could have seen coming."
    )
    Video.create(
      title: 'Lincoln',
      category: com,
      description: "Director Steven Spielberg takes on the towering legacy of Abraham Lincoln, focusing on his stewardship of the Union during the Civil War years. The biographical saga also reveals the conflicts within Lincoln's cabinet regarding the war and abolition."
    )
    expect(Video.search_by_title('%')).to be_empty
    expect(Video.search_by_title('_')).to be_empty
    expect(Video.search_by_title('Inc_ption')).to be_empty
    expect(Video.search_by_title('%ortion')).to be_empty
    expect(Video.search_by_title('Lo!n')).to be_empty
  end

  it 'should return partial matched array when search with exact string' do 
    com = Category.create(name: 'Comedies')
    Video.create(
      title: 'Inception',
      category: com,
      description: "Dom Cobb is a skilled thief, the absolute best in the dangerous art of extraction, stealing valuable secrets from deep within the subconscious during the dream state, when the mind is at its most vulnerable An enemy that only Cobb could have seen coming."
    )
    Video.create(
      title: 'Lincoln',
      category: com,
      description: "Director Steven Spielberg takes on the towering legacy of Abraham Lincoln, focusing on his stewardship of the Union during the Civil War years. The biographical saga also reveals the conflicts within Lincoln's cabinet regarding the war and abolition."
    )

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
    crime_scene = Category.create(name: 'Crime Scene II')
    v1 = Video.create(title: 'veo1', description: 'desc1', category: crime_scene, created_at: 1.day.ago)
    v2 = Video.create(title: 'veo2', description: 'desc2', category: crime_scene)
    expect(Video.search_by_title('veo').first(2)).to eq([v2,v1])
  end

  context 'has many commments' do 
    it 'get average rating' do 
      com = Category.create(name: 'Comedies')
      video = Video.create(
        title: 'Inception',
        category: com,
        description: "Dom Cobb is a skilled thief, the absolute best in the dangerous art of extraction, stealing valuable secrets from deep within the subconscious during the dream state, when the mind is at its most vulnerable An enemy that only Cobb could have seen coming."
      )
      6.times { create(:review, video_id: video.id) }

      expect(video.reviews_total_rate).to eq(video.reviews_total_rate) 
    end
  end

  it "search by title_categorized" do 
    crime_scene = Category.create(name: 'Crime Scenes')
    v1 = Video.create(title: 'video1', description: 'desc1', category: crime_scene, created_at: 1.day.ago)
    v2 = Video.create(title: 'video2', description: 'desc2', category: crime_scene)
    
    expect(Video.search_by_title_categorized('video')).not_to be_empty 
  end

  it "check SearchResult categories" do
    videos = Video.search_by_title('video')
    result = videos.reduce(SearchResult.new) do |result, video|
              result.add_videos(video)
              result
            end
    expect([result.categories]).to include(Video.search_by_title_categorized('video').keys)
  end

end
