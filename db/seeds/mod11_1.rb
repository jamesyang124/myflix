
Video.find(11) do |v| 
  File.open("#{Rails.root}/public/tmp/inception_large.jpg") do |f|
    v.large_cover = f
    File.open("#{Rails.root}/public/tmp/inception.jpg") do |ff|
      v.small_cover = ff
      v.save
    end
  end
end

Video.find(12) do |v| 
  v.large_cover = File.open("#{Rails.root}/public/tmp/lincoln_large.jpg")
  v.small_cover = File.open("#{Rails.root}/public/tmp/lincoln.jpg")
  v.save
end

Video.find(13) do |v| 
  v.large_cover = File.open("#{Rails.root}/public/tmp/monk_large.jpg")
  v.small_cover = File.open("#{Rails.root}/public/tmp/south_park.jpg")
  v.save
end

Video.find(14) do |v| 
  v.large_cover = File.open("#{Rails.root}/public/tmp/monk_large.jpg")
  v.small_cover = File.open("#{Rails.root}/public/tmp/family_guy.jpg")
  v.save
end


Video.find(15) do |v| 
  v.large_cover = File.open("#{Rails.root}/public/tmp/monk_large.jpg")
  v.small_cover = File.open("#{Rails.root}/public/tmp/monk.jpg")
  v.save
end