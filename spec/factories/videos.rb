require 'faker'

FactoryGirl.define do 
  factory :video do 
    sequence(:title) { |n| "test#{n}" }
    sequence(:description) { |n| "desc#{n}"}

    factory :search do 
      title { Faker::Name.name }
    end

  end
end