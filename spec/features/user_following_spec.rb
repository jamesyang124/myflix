require 'spec_helper'

feature 'User Following' do 
  given(:another_user) { create(:user) }
  given(:category) { Fabricate(:category) }
  given(:video) { create(:video, category: category) }
  given(:create_review) { create(:review, user: another_user, video: video) }

  background do 
    create_review
  end

  scenario "user follow and unfollow someone" do 
    sign_in
    click_on_video_on_homepage(video)

    click_link(another_user.full_name)
    click_link "Follow"
    expect(page).to have_content(another_user.full_name)

    unfollows
    expect(page).not_to have_content(another_user.full_name)

  end

  scenario "user follow themselves should not allowed" do 
    sign_in(another_user)
    
    click_on_video_on_homepage(video)
    click_link(another_user.full_name)
    expect(page).not_to have_content("Follow")
  end

  scenario "user can not follow same user when it has been followed" do 
    sign_in
    
    click_on_video_on_homepage(video)
    click_link(another_user.full_name)
    click_link "Follow"

    click_link(another_user.full_name)
    expect(page).not_to have_content("Follow")
  end

  def unfollows
    find("a[data-method='delete']").click 
  end
end