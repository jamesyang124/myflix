require 'spec_helper'

feature 'User resets password' do 
  scenario 'user successfully resets password' do 
    user = Fabricate(:user, password: "old_password")

    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in "Email Address", with: user.email
    click_button "Send Email"

  end

  scenario 'user input non-existed email' do 
    user = Fabricate(:user, password: "old_password")

    visit sign_in_path
    click_link 'Forgot Password?'
    click_button "Send Email"

    expect(page).to have_content("Email cannot be blank.")
  end

  scenario 'user use expired token' do 

  end
end