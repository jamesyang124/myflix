class InvitationsController < ApplicationController 
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end

  def create
    invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if invitation.save 
      flash[:sucess] = "Your invitation has been sent!"
      redirect_to home_path
    else 
      flash.now[:error] = "Your invitation request has been failed, please check and try again later."
      render :new
    end 
  end

private

  def invitation_params
    params.require(:invitation).permit!
  end
end