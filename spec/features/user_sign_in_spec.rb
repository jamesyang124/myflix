require 'spec_helper'
require 'faker'

feature 'user signs in' do 
  scenario 'with valid email and password' do
    user = create(:user) 
    sign_in(user)
    expect(page).to have_content user.full_name
  end

  scenario 'deactivated user sign in failed' do 
    user = Fabricate(:user, active: false)
    sign_in(user)
    expect(page).not_to have_content user.full_name
    expect(page).to have_content "Your account has been suspended, please contact customer service."
  end
end

feature 'user registration' do 
  scenario 'registration successful', {js: true, vcr: true} do

    pword = Faker::Lorem.characters(9)
    visit register_user_path
    fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_full_name', with: Faker::Name.name
    fill_in 'user_password', with: pword
    fill_in 'user_password_confirmation', with: pword

    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "314"
    find("#date_month").find("option[value='1']")
    select "2015", from: "date_year"


    click_button 'Sign Up'
    expect(page).to have_content("Sign Up Now!")
    expect(page.has_link?("Sign Up Now!")).to be_true
  end
end