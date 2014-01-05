class User < ActiveRecord::Base 
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items, -> { order("position ASC") }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password validations: false
  
  validates :password, on: :create, length: {minimum: 9}
  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email

  before_create :generate_token

  def normalize_queue_items_position
    reload.queue_items.sort_by!(&:position).each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.find_by(video_id: video.id)
  end

  def follow(another_user) 
    self.following_relationships.create(leader: another_user) if self.can_follows?(another_user) && another_user != nil
  end


  def follows?(another_user = nil) 
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follows?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64   
  end
end