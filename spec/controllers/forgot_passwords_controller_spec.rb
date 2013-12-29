require 'spec_helper'

describe ForgotPasswordsController do 
  describe "GET forgot_passwords#new" do 
    it 'logged-in user cannot visit this page' do 

    end
  end

  describe "POST forgot_passwords#create" do 
    context "fill the blank input" do 
      it "redirects to forgot_passwords#new page" do 
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "should shows the error message" do 
        post :create, email: ''
        expect(flash[:error]).not_to be_blank
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
        require 'pry';  binding.pry
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email]) 

      end
    end

    context 'fill the non -existing email in database' do 

    end

    context "rock reset email to user's email box" do 

    end
  end

end