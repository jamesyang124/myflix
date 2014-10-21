class SearchResult 
  attr_reader :data

  def initialize
    @data = {}
  end

  def add_videos(video)
    @data[video.category] ||= []
    @data[video.category] = (@data[video.category] << video) if @data[video.category].size < 6
  end

  def categories
    @data.keys
  end
end