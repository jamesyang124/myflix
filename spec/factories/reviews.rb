require 'faker'

FactoryGirl.define do 
  factory :review do 
    content { Faker::Lorem.paragraph((Random.rand()*8).to_i + 1) }
    rating { (Random.rand()*4 + 1).round(2) }
    video { Video.all.sample }
    user { User.all.sample }
  end
end