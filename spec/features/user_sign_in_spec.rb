require 'spec_helper'
require 'faker'

feature 'user signs in' do 
  scenario 'with valid email and password' do
    user = create(:user) 
    visit sign_in_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Sign In'
    expect(page).to have_content user.full_name
  end
end

feature 'user registration' do 
  scenario 'registration successful' do
    pword = Faker::Lorem.characters
    visit register_user_path
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_full_name', with: Faker::Name.name
    fill_in 'user_password', with: pword
    fill_in 'user_password_confirmation', with: pword
    click_button 'Sign Up'
    expect(page).to have_content("Sign Up Now!")
    expect(page.has_link?("Sign Up Now!")).to eq(true)
  end
end