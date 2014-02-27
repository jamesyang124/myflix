class Payment < ActiveRecord::Base 
  belongs_to :user
  default_scope { order("create_at DESC") }
end