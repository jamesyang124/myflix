require 'spec_helper'

describe PasswordResetsController do 
  describe 'GET #show' do 
    it 'should render to password reset page if token is valid' do 
      user = Fabricate(:user)
      user.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end
  it 'should redirect to token expired page if token is expired' do 
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
   end
  end

  describe 'POST #create' do 

  end
end