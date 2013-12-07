class User < ActiveRecord::Base 
  has_many :reviews
  has_many :queue_items, -> { order("position ASC") }

  has_secure_password validations: false
  
  validates :password, on: :create, length: {minimum: 9}
  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email

  def normalize_queue_items_position
    reload.queue_items.sort_by!(&:position).each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end
end