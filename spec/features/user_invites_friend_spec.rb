require 'spec_helper'
require 'faker'

feature 'User invites friend' do 
  scenario 'user successfully invites a friend and invitaion is accepted' do 

    user = Fabricate(:user)
    sign_in(user)

    recipient_email = Faker::Internet.email
    recipient_name = Faker::Name.name

    invite_friend(recipient_name, recipient_email)
    
    friend_accept_invitation(recipient_name, recipient_email)
    
    friend_sign_in(recipient_email)

    friend_follow_inviter(user)

    inviter_follow_friend(user, recipient_name)

    clear_emails
  end


  def invite_friend(recipient_name, recipient_email)
    visit new_invitation_path
    fill_in "Friend's Name", with: recipient_name
    fill_in "Friend's Email Address", with: recipient_email
    fill_in "Invitation Message", with: Faker::Lorem.paragraph(4)
    click_button "Send Invitation" 

    expect(page).to have_content "has been sent!"
    sign_out
  end 

  def friend_accept_invitation(recipient_name, recipient_email)
    open_email(recipient_email)
    current_email.click_link "Register for myflix"
 
    expect(find("input#user_email").value).to eq(recipient_email)
    expect(page).to have_content "Register"

    fill_in "user_full_name", with: recipient_name
    fill_in "user_password", with: "123456789"
    fill_in "user_password_confirmation", with: "123456789"
    click_button "Sign Up"

    expect(page).to have_content "Sign In"
  end

  def friend_sign_in(recipient_email)
    click_link "Sign In"
    fill_in "Email Address", with: recipient_email
    fill_in "Password", with: "123456789"
    click_button "Sign In"

    expect(page).to have_content "You have signed in!"  
  end

  def friend_follow_inviter(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_follow_friend(user, recipient_name)
    sign_in(user)
    click_link "People"
    expect(page).to have_content recipient_name
  end
end