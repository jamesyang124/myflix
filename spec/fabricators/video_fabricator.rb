require 'faker'

Fabricator(:video) do 
  title { "Fabricator" }
  description { "Fab description" }
  category { Fabricate.build(:category) }
end