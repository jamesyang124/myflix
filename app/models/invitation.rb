class Invitation < ActiveRecord::Base 
  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_email, :recipient_name, :message
end