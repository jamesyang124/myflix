source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'haml-rails'
gem 'bootstrap-sass', '~> 2.2.2.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'bootstrap_form', "~> 1.0.0"
gem 'simple_form'
gem 'simplecov', :require => false, :group => :test
gem 'sidekiq'
gem 'unicorn'
gem 'carrierwave'
gem 'mini_magick'
gem 'figaro'
gem 'stripe'
gem 'fog'
gem 'pg'


group :assets do
  gem 'sass-rails',   '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'fabrication'
  
  # for Sidekiq web UI
  gem 'sinatra', require: false
  gem 'slim'
end

group :development do 
  gem 'letter_opener'
end

group :test do
  gem 'shoulda-matchers', '~> 2.4.0'
  gem 'factory_girl_rails', '~> 4.3.0'
  gem "faker", '~> 1.2.0'
  gem 'capybara', "~> 2.1.0"
  gem 'launchy'
  gem 'capybara-email', '~> 2.2.0'
  gem 'vcr'
  gem 'webmock', '~> 1.15.2'
end

group :production do
  gem 'rails_12factor'
end

gem 'jquery-rails'
