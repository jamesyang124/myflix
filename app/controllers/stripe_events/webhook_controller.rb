class StripeEvents::WebhookController < ApplicationController 
  @@list = nil

  def index
    render text: @@list
  end

  def receive
    @@list = params
    respond_to do |format|
      format.html { head :ok }
      format.json { render text: params }
    end

  end
end