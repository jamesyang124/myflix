require 'spec_helper'

describe UsersController do 
  describe  'GET #new' do 
    it 'has new User model object' do 
      fake_user = create(:user)
      
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'render the users#new template' do 
      get :new
      expect(response).to render_template 'users/new'
    end
  end

end