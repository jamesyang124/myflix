require 'faker'

FactoryGirl.define do 
  factory :review do 
    content { Faker::Lorem.paragraph((Random.rand()*8).to_i + 1) }
    rating { (Random.rand()*4 + 1).round }
    
    factory :invalid_review do 
      content { nil }
      rating { (Random.rand()*4 + 1).round }
    end
  end
end