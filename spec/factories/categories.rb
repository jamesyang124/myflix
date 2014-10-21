require 'faker'

FactoryGirl.define do
  factory :category do 
    name 'Uncategoried' 

    factory :valid_category do
      name { Faker::Lorem.word }
    end
  end 
end