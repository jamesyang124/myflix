require 'spec_helper'

feature "Admin add new video" do 
  scenario "admin successfully ad new video" do 
    admin = Fabricate(:admin)
    sign_in admin
  
    visit new_admin_video_path 
    fill_in "Title", with: "Nobunagaa"
    select "Dramas", from: "Category"
    fill_in "Description", with: "Japan!!"
    attach_file "Large cover", "spec/support/uploads/inception_large.jpg"
    attach_file "Small cover", "spec/support/uploads/inception.jpg"
    fill_in "Video URL", with: "https://www.youtube.com/watch?v=nxNLzpeBqfc"
    click_button "Add Video"
  
    sign_out
    sign_in 
  
    v = Video.find_by(title: "Nobunagaa")
    visit video_path(v)
    #save_and_open_page
    expect(page).to have_selector("img[src='/uploads/inception_large.jpg']")
    expect(page).to have_selector("a[href='https://www.youtube.com/watch?v=nxNLzpeBqfc']")
  end
end