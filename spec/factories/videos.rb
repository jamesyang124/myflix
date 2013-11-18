FactoryGirl.define do 
  factory :video do 
    sequence(:title) { |n| "test#{n}" }
    sequence(:description) { |n| "desc#{n}"}
  end
end