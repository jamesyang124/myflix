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

    context 'with valid input' do
      before :each do 
        set_current_user
        post :create, invitation: 
        { 
          message: Faker::Lorem.paragraph(3),
          recipient_email: Faker::Internet.email,
          recipient_name: Faker::Name.name 
        } 
      end

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to home_path if successed" do 
        expect(response).to redirect_to new_invitation_path
      end

      it 'creates a new record in "invitations" table' do 
        expect(Invitation.count).to eq(1)
      end

      it 'sends an email to recipient' do 
        expect(ActionMailer::Base.deliveries.last.to).to eq([Invitation.last.recipient_email])
      end

      it 'sets flash success message' do 
        expect(flash[:success]).not_to be_blank
      end
    end

    context 'with invalid input' do       
      before :each do 
        set_current_user        
      end

      after { ActionMailer::Base.deliveries.clear }

      let(:invalid_invitation) { post :create, invitation: { recipient_name: nil, recipient_email: nil, message: nil} }

      it 'render to new template' do 
        invalid_invitation
        expect(response).to render_template :new
      end

      it "remain @invitation in create action so can be used in new template" do 
        invalid_invitation
        expect(assigns(:invitation)).to be_present
      end

      it 'does not create a new record in Invitation table' do
        expect{ 
          post :create, invitation: 
          { 
            recipient_name: nil, 
            recipient_email: nil, 
            message: nil
          } 
        }.not_to change(Invitation, :count).from(0).to(1)
      end

      it 'does not send out the email' do 
        invalid_invitation
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'sets flash error message' do 
        invalid_invitation
        expect(flash.now[:error]).to be_present
      end

    end
  end

end