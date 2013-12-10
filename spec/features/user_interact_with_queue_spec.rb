require 'spec_helper'
require 'faker'

feature 'user interacts with queue' do 
  scenario 'user adds and reorders videos in the queue' do 
    category = create(:valid_category)
    video1 = create(:video, category: category)
    video2 = create(:video, category: category)
    video3 = create(:video, category: category)
    
    sign_in
    find("a[href='/videos/#{video1.id}']").click
    expect(page).to have_content(video1.title)
    
    click_link('+ My Queue')
    expect(page).to have_content(video1.title)

    visit video_path(video1)
    expect(page).not_to have_content("+ My Queue")

    visit home_path
    find("a[href='/videos/#{video2.id}']").click
    click_link('+ My Queue')

    visit home_path
    find("a[href='/videos/#{video3.id}']").click
    click_link('+ My Queue')

    fill_in("video_#{video1.id}", with: "2")
    fill_in("video_#{video2.id}", with: "3")
    fill_in("video_#{video3.id}", with: "1")
    click_button "Update Instant Queue"
    
    expect(find("#video_#{video1.id}").value).to eq("2")
    expect(find("#video_#{video2.id}").value).to eq("3")
    expect(find("#video_#{video3.id}").value).to eq("1")

  end

end