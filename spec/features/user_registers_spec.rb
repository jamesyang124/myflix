require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do 
  background do 
    visit register_user_path
  end

  scenario 'with valid user and credit card info' do 
    fill_in_valid_user_info
    fill_in_card_info("4242424242424242")

    click_button 'Sign Up'

    expect(page).to have_content("Thank you for your payment for Myflix.")
  end

  scenario 'with valid user and declined credit card info' do 
    fill_in_valid_user_info
    fill_in_card_info("4000000000000002")

    click_button 'Sign Up'

    expect(page).to have_content("Your card was declined.")
  end

  scenario 'with valid user and invalid credit card info' do 
    fill_in_valid_user_info
    fill_in_card_info("40")

    click_button 'Sign Up'

    expect(page).to have_content("This card number looks invalid")
  end

  scenario 'with invalid user and invalid credit card info' do 
    fill_in_invalid_user_info
    fill_in_card_info("123")

    click_button 'Sign Up'
    
    # JS validation before sending request to server.
    expect(page).to have_content("This card number looks invalid")
  end

  scenario 'with invalid user and valid credit card info' do 
    fill_in_invalid_user_info
    fill_in_card_info("4242424242424242")

    click_button 'Sign Up'

    expect(page).to have_content("Invalid user information, please fill in again.")
  end


  scenario 'with invalid user and declined credit card info' do 
    fill_in_invalid_user_info
    fill_in_card_info("4000000000000002")

    click_button 'Sign Up'

    expect(page).to have_content("Invalid user information, please fill in again.")
  end

  def fill_in_valid_user_info
    fill_in "user_email", with: "John@example.com"
    fill_in "user_full_name", with: "John Doe"
    fill_in "user_password", with: "123456789"
    fill_in "user_password_confirmation", with: "123456789"
  end

  def fill_in_card_info(card_no)
    fill_in "Credit Card Number", with: card_no
    fill_in "Security Code", with: "314"
    find("#date_month").find("option[value='1']")
    select "2015", from: "date_year"
  end

  def fill_in_invalid_user_info
    fill_in "user_email", with: "John@example.com"
  end

end