require 'spec_helper'

describe Category do
  describe 'test Validation & Association & Saves' do
    before :each do 
      @crime_scene = Category.create(name: 'Crime Scene')
      @test_video1 = Video.create(title: 'video1', description: 'desc1', category: @crime_scene)  
      @test_video2 = Video.create(title: 'video2', description: 'desc2', category: @crime_scene)  
    end 
  
    it 'saves itself' do
      category = FactoryGirl.build(:category) 
      category.save
      expect(Category.find category).to eq(category)
    end
  
    it 'has many videos' do
      expect(@crime_scene.videos).to include(@test_video1, @test_video2)  
      expect(@crime_scene.videos).to eq([@test_video1, @test_video2]) 
      should have_many(:videos) 
    end 
  
    it 'is valid with name' do 
      should validate_presence_of(:name)
      should validate_uniqueness_of(:name)
    end
  end

  describe 'test Cateogry#recent_videos' do
    before :each do 
      @category = Category.first
      2.times { |_| create(:video, category: @category) }
    end

    it 'return less than 6 recent-created videos' do
      expect(@category.reload.recent_videos).to have_at_most(6).items
    end 

    it 'return at most 6 recent-created videos' do
      5.times { |_| create(:video, category: @category) }
      expect(@category.reload.recent_videos).to have_at_most(6).elements
    end
  end
end