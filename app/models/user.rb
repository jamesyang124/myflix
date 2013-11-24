class User < ActiveRecord::Base 
  has_many :reviews

  has_secure_password validations: false
  
  validates :password, on: :create, length: {minimum: 9}
  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email
end