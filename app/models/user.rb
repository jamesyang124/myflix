class User < ActiveRecord::Base 

  has_secure_password validattions: false
  
  validates :password, on: :create, length: {minimum: 8}
  validates_presence_of :full_name, :password, :email
  validates_uniqueness_of :email
end