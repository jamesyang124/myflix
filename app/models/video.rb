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

  def self.search_by_title_categorized(videos)
    videos.reduce({}) do |collection, video|
      collection[video.category] ||= []
      collection[video.category] = (collection[video.category] << video) if collection[video.category].size < 6
      collection
    end
  end
end