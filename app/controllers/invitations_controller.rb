class InvitationsController < ApplicationController 
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save 
      AppMailersWorker.delay.perform_async(@invitation.id, @invitation.class.to_s, :send_invitation)
      flash[:success] = "Your invitation for #{@invitation.recipient_name} has been sent!"
      redirect_to new_invitation_path
    else 
      flash.now[:error] = "Your invitation has been failed to sent for, please check and try again later."
      render :new
    end 
  end

private

  def invitation_params
    params.require(:invitation).permit!
  end
end