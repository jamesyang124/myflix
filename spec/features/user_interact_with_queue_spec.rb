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

    within(:xpath, "//tr[contains(., '#{video1.title}')]") do 
      fill_in "queue_items[][position]", with: 2
    end

    within(:xpath, "//tr[contains(., '#{video2.title}')]") do 
      fill_in "queue_items[][position]", with: 3
    end

    within(:xpath, "//tr[contains(., '#{video3.title}')]") do 
      fill_in "queue_items[][position]", with: 1
    end
    
    # by xpath, do not need to create customed attribute by extra coding work in queue_items/index.html.haml
    expect(find(:xpath, "//tr[contains(., '#{video1.title}')]//input[@type='text']").value).to eq("2")
    expect(find(:xpath, "//tr[contains(., '#{video2.title}')]//input[@type='text']").value).to eq("3")
    expect(find(:xpath, "//tr[contains(., '#{video3.title}')]//input[@type='text']").value).to eq("1")

    # find by customed attribute
    find("input[data-video-id='#{video1.id}']").set(2)
    find("input[data-video-id='#{video2.id}']").set(3)
    find("input[data-video-id='#{video3.id}']").set(1)
    
    click_button "Update Instant Queue"
    
    expect(find("input[data-video-id='#{video1.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{video2.id}']").value).to eq("3")
    expect(find("input[data-video-id='#{video3.id}']").value).to eq("1")

  end

end