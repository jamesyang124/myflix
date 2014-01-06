require 'faker'

Fabricator(:user) do 
    pword = Faker::Lorem.characters(9)
    email {  Faker::Internet.email }
    full_name { Faker::Name.name }
    password { pword }
    password_confirmation { pword }
end