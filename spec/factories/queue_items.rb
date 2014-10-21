require 'faker'

FactoryGirl.define do 
  factory :queue_item do 
    position { Faker::Number.digit }
  end
end