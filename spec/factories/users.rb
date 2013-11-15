require 'faker'

FactoryGirl.define do 
  factory :user do 
    pword = Faker::Lorem.characters
    email {  Faker::Internet.email }
    full_name { Faker::Name.name }
    password { pword }
    password_confirmation { pword }


    factory :invalid_name do 
      full_name nil
    end

    factory :invalid_email do 
      email nil
    end

    factory :invalid_password do 
      password nil
    end
    
  end
end