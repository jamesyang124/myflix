require 'spec_helper'

feature "Admins see payments" do
  background do 
    user = Fabricate(:user, full_name: "Johnny G", email: "johnny@try.com")
    Fabricate(:payment, amount: 999, user: user)
  end

  scenario 'admin can see payments page' do 
    sign_in(Fabricate(:admin))
    visit admin_payments_path

    expect(page).to have_content("$9.99")
    expect(page).to have_content("Johnny G")
    expect(page).to have_content("johnny@try.com")
  end

  scenario 'user cannot see payments page' do 
    sign_in(Fabricate(:user))
    visit admin_payments_path

    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Johnny G")
    expect(page).not_to have_content("johnny@try.com")
  end
end