require 'spec_helper'

describe PasswordResetsController do 
  describe 'GET #show' do 
    it 'should render to password reset page if token is valid' do 
      user = Fabricate(:user)
      user.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end
  it 'sets @token' do
      user = Fabricate(:user)
      user.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345') 
  end

  it 'should redirect to token expired page if token is expired' do 
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
   end
  end

  describe 'POST #create' do 
    context 'with valid token' do 
      it 'update password' do 
        user = Fabricate(:user, password: "old pwd III")
        user.update_column(:token, '12345')
        post :create, token: '12345', password: "new pwd III"

        expect(user.reload.authenticate('new pwd III')).not_to be_false 
      end

      it 'redirect to sign_in page' do
        user = Fabricate(:user)
        user.update_column(:token, '12345')
        post :create, token: '12345', password: "new pwd III"

        expect(response).to redirect_to sign_in_path
      end

      it 'sets the flash successful message' do 
        user = Fabricate(:user)
        user.update_column(:token, '12345')
        post :create, token: '12345', password: "new pwd III"

        expect(flash[:success]).to eq("You have successfully reset password.")
      end

      it 'regenerate user token' do
        user = Fabricate(:user)
        user.update_column(:token, '12345')
        post :create, token: '12345', password: "new pwd III"

        expect(user.reload.token).not_to eq("12345")

      end 
    end

    context 'with invalid token' do 
      it 'redirect_to expired_token_path' do 
        user = Fabricate(:user)
        post :create, token: '12345', password: "new pwd III"

        expect(response).to redirect_to expired_token_path
      end
      
    end
  end
end