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
