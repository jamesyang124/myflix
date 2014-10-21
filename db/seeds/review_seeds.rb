require 'faker'

module ReviewSeeds
  def self.create_users
    users = User.all
    if users.blank? || users.size < 8
      ['user_seeds', Rails.env].each do |seed| 
          seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
          if File.exists?(seed_file)
            puts "Loading #{seed} data"
            require seed_file
          end
      end
      UserSeeds::create_user
    end
  end

  def self.create_videos
    videos = Video.all
    if videos.blank?
      ['video_seeds', Rails.env].each do |seed| 
        seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
        if File.exists?(seed_file)
          puts "Loading #{seed} data"
          require seed_file
        end
      end
      VideoSeeds::category_creation
      Video.create(VideoSeeds::video_collection)  
    end 
  end

  def self.create_reviews
    create_users()
    create_videos()
    users = User.all
    Video.all.each do |v| 
      if v.reviews.blank?
        (Random.rand()*8 + 1).to_i.times do 
          review = Review.create( content: Faker::Lorem.paragraph((Random.rand*8).to_i + 1), 
                          rating: (Random.rand*4 + 1).round, 
                          video: v, 
                          user: users.sample)
          review.created_at -= ((Random.rand(1000)*100000).to_i + 1)
          review.save
        end
      end
    end
  end
end