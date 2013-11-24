require 'faker'

Fabricator(:video) do 
  title { "Fabricator" }
  description { "Fab description" }
  category { Fabricate.build(:category) }
end

Fabricator(:category) do 
  name { Faker::Name.name }
end