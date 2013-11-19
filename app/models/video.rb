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

  def self.search_by_title_categorized(videos, category)
    videos.select do |v| 
      v.category == category
    end.first(6)
  end
end