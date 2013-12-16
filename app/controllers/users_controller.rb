class UsersController < ApplicationController 
  before_action :require_user, only: [:show]

  def new
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(create_user)
    if @user.save 
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find params[:id]
  end

  private 

  def create_user
    params.require(:user).permit(:full_name, :password, :email, :password_confirmation)
  end
end