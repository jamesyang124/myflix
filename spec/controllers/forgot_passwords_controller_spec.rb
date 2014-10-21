require 'spec_helper'
require 'faker'

describe ForgotPasswordsController do 
  describe "POST forgot_passwords#create" do 
    after { ActionMailer::Base.deliveries.clear }

    context "fill the blank input" do 
      it "redirects to forgot_passwords#new page" do 
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "should shows the error message" do 
        post :create, email: ''
        expect(flash[:error]).to eq("Email cannot be blank.")
      end
    end

    context 'fill the existing email in database ' do 
      it 'redirect to the forgot password confirmation page.' do 
        user = Fabricate(:user)
        post :create, email: user.email
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it 'sends out the email to the email address' do 
        user = Fabricate(:user)
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email]) 

      end
    end

    context 'fill the non-existing email in database' do 
      it 'redirects to forgot password page' do
        post :create, email: Faker::Internet.email
        expect(response).to redirect_to forgot_password_path
      end
      it 'show error message' do 
        post :create, email: Faker::Internet.email
        expect(flash[:error]).to eq("Email input does not exist in system.") 
      end
    end
  end

end