def set_current_user(user = nil)
  @user = create(:registered_user)
  session[:user_id] = (user || @user).id
  @user = user unless user.nil?
end

def set_new_queue_item_instance
  @video = create(:video)
  @user = create(:registered_user)
  @queue_item = create(:queue_item, video: @video, user: @user)
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user = nil)
  user = a_user || create(:user)
  visit sign_in_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Sign In'
end

def sign_out
  visit sign_out_path
end

def click_on_video_on_homepage(video)
  find("a[href='/videos/#{video.id}']").click
end

def set_current_admin
  set_current_user(Fabricate(:admin))
end