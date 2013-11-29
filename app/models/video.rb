class Video < ActiveRecord::Base 
  has_many :reviews, -> { order("created_at DESC") }
  belongs_to :category
  validates_presence_of :title, :description

  #delegate :name, to: :category

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

  def reviews_total_rate
    total_rate = 0.00
    total_rate = reviews.reduce(total_rate) do |sum, c| 
      sum += c.rating
    end
    unless reviews.blank?
      total_rate /= reviews.count 
      total_rate.round(1)
    end
  end

end