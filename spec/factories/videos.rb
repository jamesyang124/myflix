require 'faker'

FactoryGirl.define do 
  factory :video do 
    sequence(:title) { |n| "test#{n}" }
    sequence(:description) { |n| "desc#{n}"}

    factory :search do 
      title { Faker::Lorem.sentence(8) }
    end

  end
end