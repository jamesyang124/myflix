require 'spec_helper'

describe Admin::VideosController do 
  describe "GET #new" do
    it_behaves_like "require_sign_in" do 
      let(:action) { get :new }
    end

    context "current_user is an admin user" do 
      it 'sets @video to new video' do 
        set_current_admin
        get :new
        expect(assigns(:video)).to be_a_new(Video)
      end
  
      it 'render new template' do 
  
      end
    end 

    context "current_user is not an admin user" do 
      it 'redirect to home path' do
        set_current_user 
        get :new
        expect(response).to redirect_to home_path
      end

      it "shoots flash error message to non-admin user" do 
        set_current_user
        get :new
        expect(flash[:error]).to be_an_instance_of(String) 
      end
    end
  end

  describe "GET #index" do 

  end
end