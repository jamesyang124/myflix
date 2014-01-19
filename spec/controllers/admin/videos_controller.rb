require 'spec_helper'

describe Admin::VideosController do 
  describe "GET #new" do
    it_behaves_like "require_sign_in" do 
      let(:action) { get :new }
    end

    it_behaves_like "require_admin" do 
      let(:action) { get :new }
    end

    context "current_user is an admin user" do 
      it 'sets @video to new video' do 
        set_current_admin
        get :new
        expect(assigns(:video)).to be_a_new(Video)
      end
  
      it 'render new template' do 
        set_current_admin
        get :new 
        expect(response).to render_template :new
      end
    end

    context "current_user is not an admin user" do 
      it "shoots flash error message to non-admin user" do 
        set_current_user
        get :new
        expect(flash[:error]).to be_an_instance_of(String) 
      end
    end 
  end

  describe "POST #create" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create }
    end

    it_behaves_like "require_admin" do 
      let(:action) { post :create }
    end

    context "current_user is an admin user" do 
      describe "input valid data" do
        before(:each) { set_current_admin }

        it "creates the video" do
          category = Fabricate(:category) 
          video = Fabricate(:video, category: category)
          
          expect{ 
            post :create, video: { title: video.title, description: video.description }
          }.to change(Video, :count).by(1)
        end

        it 'redirect to add new video page' do
          category = Fabricate(:category) 
          video = Fabricate(:video, category: category)
          post :create, video: { title: video.title, description: video.description }
          
          expect(response).to redirect_to new_admin_video_path
        end

        it 'sets the flash success message' do 
          category = Fabricate(:category) 
          video = Fabricate(:video, category: category)
          post :create, video: { title: video.title, description: video.description }
          
          expect(flash[:success]).to be_an_instance_of(String)
        end
      end

      describe "input invalid data" do 
        before(:each) { set_current_admin }

        it 'does not create the video' do 
          expect{ 
            post :create, video: { title: nil, description: nil } 
          }.not_to change(Video, :count).by(1)
        end

        it 'renders new template' do 
          post :create, video: { title: nil, description: nil }
          expect(response).to render_template :new
        end

        it 'sets @video' do 
          post :create, video: { title: nil, description: nil }
          expect(assigns(:video)).to be_a_new(Video)
        end

        it 'shoot flash error message' do 
          post :create, video: { title: nil, description: nil }
          expect(flash[:error]).to be_present
        end
      end
    end

    context "current_user is not an admin user" do 
      it "shoots flash error message to non-admin user" do 
        set_current_user
        post :create
        expect(flash[:error]).to be_an_instance_of(String) 
      end
    end
  end
end