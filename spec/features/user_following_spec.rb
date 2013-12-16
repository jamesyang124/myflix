require 'spec_helper'

feature 'User Following' do 
  scenario "user follow and unfollow someone" do 
    
    another_user = create(:user)
    category = Fabricate(:category)
    video = create(:video, category: category)
    create(:review, user: another_user, video: video)

    sign_in
    click_on_video_on_homepage(video)

    click_link(another_user.full_name)
    click_link "Follow"
    expect(page).to have_content(another_user.full_name)

    unfollows
    expect(page).not_to have_content(another_user.full_name)
  end

  def unfollows
    find("a[data-method='delete']").click 
  end
end