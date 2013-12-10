require 'spec_helper'
require 'faker'

feature 'user interacts with queue' do 
  scenario 'user adds and reorders videos in the queue' do 
    category = create(:valid_category)
    video1 = create(:video, category: category)
    video2 = create(:video, category: category)
    video3 = create(:video, category: category)
    
    sign_in

    add_video_to_queue(video1)
    expect_video_in_queue(video1)

    visit video_path(video1)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(video2)
    add_video_to_queue(video3)

    # By xpath, do not need to create customed attribute by extra coding work in queue_items/index.html.haml
    set_video_position(video1, 2)
    set_video_position(video2, 3)
    set_video_position(video3, 1)
    update_queue

    expect_video_position(video1, 2)
    expect_video_position(video2, 3)
    expect_video_position(video3, 1)

    # find by customed attribute

    find_by_customed_attribute(video1, 3)
    find_by_customed_attribute(video2, 1)
    find_by_customed_attribute(video3, 2)
    update_queue
    
    expect_video_position_by_customed_attribute(video1, 3)
    expect_video_position_by_customed_attribute(video2, 1)
    expect_video_position_by_customed_attribute(video3, 2)    

  end

  def expect_video_in_queue(video)
    expect(page).to have_content(video.title)  
  end

  def expect_link_not_to_be_seen(label)
    expect(page).not_to have_content(label)
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(., '#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(., '#{video.title}')]") do 
      fill_in "queue_items[][position]", with: position
    end    
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link('+ My Queue')  
  end

  def find_by_customed_attribute(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def expect_video_position_by_customed_attribute(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end  

  def update_queue
    click_button "Update Instant Queue"
  end
end