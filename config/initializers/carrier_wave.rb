CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        
      :aws_access_key_id      => ENV["S3_KEY"],                
      :aws_secret_access_key  => ENV["S3_SECRET"],         
    }
    config.cache_dir = "#{Rails.root}/tmp/uploads"                  
    # To let CarrierWave work on heroku
 
    config.fog_use_ssl_for_aws = false
    config.fog_directory    = ENV['S3_BUCKET_NAME']
    config.asset_host         = "#{ENV['S3_ASSET_URL']}/#{ENV['S3_BUCKET_NAME']}"
  else 
    config.storage = :file 
    config.enable_processing = Rails.env.development?
  end
end