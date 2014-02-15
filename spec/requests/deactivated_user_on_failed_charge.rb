require 'spec_helper'

feature 'Deactivated user on failed charge' do 
  let(:event_data) do 
    {
      "id"=> "evt_103V2m225BGP9bWCf1Ucp7KQ",
      "created"=> 1392448639,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_103V2m225BGP9bWC9T6WQkAb",
          "object"=> "charge",
          "created"=> 1392448639,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_103V2m225BGP9bWCrXUc5EgQ",
            "object"=> "card",
            "last4"=> "0341",
            "type"=> "Visa",
            "exp_month"=> 2,
            "exp_year"=> 2015,
            "fingerprint"=> "aSJlbcPpOriuzQhS",
            "customer"=> "cus_3V1zhEIU6qX4Sl",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil
          },
          "captured"=> false,
          "refunds"=> [],
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_3V1zhEIU6qX4Sl",
          "invoice"=> nil,
          "description"=> "fail charge",
          "dispute"=> nil,
          "metadata"=> {}
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_3V2megR3WwqR6L"
    }
  end


  scenario 'deactivates a user with webhook data from stripe fro charge failed', :vcr do 
    user = Fabricate(:user, customer_token: "cus_3V1zhEIU6qX4Sl")
    post '/stripe_events', event_data

    expect(user.reload).not_to be_active 
  end
end