require 'faker'

module CommentSeeds
  def self.create_users
    users = User.all
    if users.blank? || users.size < 4
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

  def self.create_comments
    create_users()
    create_videos()
    users = User.all
    Video.all.each do |v| 
      if v.comments.blank?
        (Random.rand()*10).to_i.times do 
          Comment.create(opinion: Faker::Lorem.paragraph(Random.rand()*8), rating: (Random.rand()*5).round(2), video: v, user: users.sample)
        end
      end
    end
  end
end