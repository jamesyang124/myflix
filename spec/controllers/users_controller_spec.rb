require 'spec_helper'

describe UsersController do 
  describe  'GET #new' do 
    it 'has new User model object' do 
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end
end