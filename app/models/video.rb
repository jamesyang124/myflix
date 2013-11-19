class Video < ActiveRecord::Base 
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title(str)
    if str.blank? || str.match(/[%|_|!]/)
      []
    else
      # Postgre SQL syntax
      self.where(["LOWER(title) LIKE LOWER(?)", "%#{str}%"]).order("created_at DESC")
    end
  end

  def self.search_by_title_categorized(search_term)
    videos = search_by_title(search_term)
    result = videos.reduce(SearchResult.new) do |result, video|
              result.add_videos(video)
              result
            end
    result.data
  end
end