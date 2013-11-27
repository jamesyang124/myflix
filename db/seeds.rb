# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#5.times do |f|
#  Video.create(title: 'SouthPark', small_cover_url: '/tmp/monk.jpg', description: "Wonderful #{f} data", large_cover_url: '/tmp/monk_large.jpg')
#end

# If you are first time to run this file, uncomment all from mod 1 to mod n.

# ['mod1', Rails.env].each do |seed| 
#   seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
#   if File.exists?(seed_file)
#     puts "Loading #{seed} seed data"
#     require seed_file
#   end
# end

# ['mod2', Rails.env].each do |seed| 
#   seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
#   if File.exists?(seed_file)
#     puts "Loading #{seed} seed data"
#     require seed_file
#   end
# end

#['mod3', Rails.env].each do |seed| 
#  seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
#  if File.exists?(seed_file)
#    puts "Loading #{seed} files"
#    require seed_file
#  end
#end 

['mod4', Rails.env].each do |seed| 
  seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
  if File.exists?(seed_file)
    puts "Loading #{seed} files"
    require seed_file
  end
end 