['review_seeds', Rails.env].each do |seed| 
  seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
  if File.exists?(seed_file)
    puts "Loading #{seed} data"
    require seed_file
  end
end  

ReviewSeeds::create_reviews