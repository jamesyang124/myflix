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

  def require_activation 
    if !current_user.active and Payment.where(user_id: current_user).last.end_date > Time.now.to_i
      flash[:info] = "please subscribe to continue service."
      redirect_to plans_path
    end
  end
end
