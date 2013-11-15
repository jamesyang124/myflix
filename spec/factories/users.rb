require 'faker'

FactoryGirl.define do 
  factory :users do 
    email {  Faker::Internet.email }
    full_name { Faker::Name.name }
    password { Faker::Internet.password }
  end
end