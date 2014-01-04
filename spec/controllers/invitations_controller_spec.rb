require 'spec_helper'

describe InvitationsController do
  describe "GET invitations#new" do 
    it_behaves_like "require_sign_in" do 
      let(:action) { get :new }
    end

    it "sets @invitation to a new invitationß" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe "POST invitations#create" do
    it_behaves_like "require_sign_in" do 
      let(:action) { post :create }
    end

    describe 'with valid input' do

      before :each do 
        set_current_user
        post :create, invitation: \
        { message: Faker::Lorem.paragraph(3),
          recipient_email: Faker::Internet.email,
          recipient_name: Faker::Name.name 
        } 
      end

      it "redirects to home_path if successed" do 
        expect(response).to redirect_to home_path
      end

      it 'creates a new record in "invitations" table' do 
        expect(Invitation.count).to eq(1)
      end
    end

    context 'with invalid input' do 

    end
  end

end