class CategoriesController < ApplicationController 
  before_action :require_user, :require_activation 
  def show 
    @category = Category.find params[:id]
  end
end