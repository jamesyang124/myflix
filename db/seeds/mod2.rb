['video_seeds', Rails.env].each do |seed| 
  seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
  if File.exists?(seed_file)
    puts "Loading #{seed} data"
    require seed_file
  end
end  

video_collection = VideoSeeds::video_collection

video_collection.each do |v|
  v[:title] = v[:title] << " II"
  v[:category] = Category.where(name: 'Comedies').first
  Video.create(v)
end





