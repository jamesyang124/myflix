class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # for nil case, !!nil = flase
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:info] = "Accessed reserved for members only, please sign in first."
      redirect_to sign_in_path
    end
  end

  def require_admin
    if !current_user.admin
      flash[:error] = "You have no permission to view the page."
      redirect_to home_path
    end
  end
end
