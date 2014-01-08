class SendInvitationsWorker 
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(invitation_id)
    invitation = Invitation.find(invitation_id)
    AppMailers.send_invitation(invitation).deliver
  end
end