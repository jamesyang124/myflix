require 'spec_helper'

feature 'User resets password' do 
  scenario 'user successfully resets password' do 
    user = Fabricate(:user, password: "old_password")

    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in "Email Address", with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link 'Reset My Password'
    expect(page).to have_content "New Password"

    fill_in 'New Password', with: "new_password"
    click_button "Reset Password"
    expect(page).to have_content "You have successfully reset password."

    fill_in "Email Address", with: user.email
    fill_in "Password", with: "new_password"
    click_button 'Sign In'
    expect(page).to have_content "Welcome, #{user.full_name}"
    expect(find("div#flash_notice").text).to eq("You have signed in! Enjoy!")

  end

  scenario 'user input non-existed email' do 
    user = Fabricate(:user, password: "old_password")

    visit sign_in_path
    click_link 'Forgot Password?'
    click_button "Send Email"

    expect(page).to have_content("Email cannot be blank.")
  end

  scenario 'user use expired token' do 
    user = Fabricate(:user, password: "old_password")

    visit sign_in_path
    click_link 'Forgot Password?'
    fill_in "Email Address", with: user.email
    click_button "Send Email"

    open_email(user.email)
    current_email.click_link 'Reset My Password'
    expect(page).to have_content "New Password"

    fill_in 'New Password', with: "new_password"
    click_button "Reset Password"
    expect(page).to have_content "You have successfully reset password."

    open_email(user.email)
    current_email.click_link 'Reset My Password'
    expect(page).to have_content("Your reset password link is expired.")

  end
end