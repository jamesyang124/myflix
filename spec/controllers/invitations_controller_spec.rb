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
end