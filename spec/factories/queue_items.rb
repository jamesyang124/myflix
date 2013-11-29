require 'faker'

FactoryGirl.define do 
  factory :queue_item do 
    position { Faker::Number.number(1) }
  end
end