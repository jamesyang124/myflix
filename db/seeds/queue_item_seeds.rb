require 'faker'

module QueueItemSeeds
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

  def self.create_qs 
    create_users()
    create_videos()
    
    User.all.sample(3).each do |u|
      if u.queue_items.blank?
        s = 1
        1.upto(6) do
          s += 1 if u.queue_items.create(position: s, video: Video.all.sample, user: u).id
        end
      end
    end
  end
end