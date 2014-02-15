require "spec_helper"

describe 'Create payment on successful charge' do
  let(:event_data) do 
    {
      "id"=> "evt_103Ux1225BGP9bWCVCXmzLp3",
      "created"=> 1392427214,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_103Ux1225BGP9bWCBw5lSZ8R",
          "object"=> "charge",
          "created"=> 1392427214,
          "livemode"=> false,
          "paid"=> true,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "card"=> {
            "id"=> "card_103Ux1225BGP9bWCJFVbP3ng",
            "object"=> "card",
            "last4"=> "4242",
            "type"=> "Visa",
            "exp_month"=> 2,
            "exp_year"=> 2015,
            "fingerprint"=> "9ejOe3jqfcNEBbko",
            "customer"=> "cus_3Ux1JsdfxOoeWa",
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
          "captured"=> true,
          "refunds"=> [],
          "balance_transaction"=> "txn_103Ux1225BGP9bWCzMOPrkVp",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_3Ux1JsdfxOoeWa",
          "invoice"=> "in_103Ux1225BGP9bWCrsgEmQqz",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {}
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_3Ux101Gd2bcTbZ"
    }
  end

  it "create a payment with webhook from stripe for charge successed", :vcr do 
    post '/stripe_events', event_data    
  
    expect(Payment.count).to eq(1)
  end

  it "crate a payment model object associate with user", :vcr do
    customer_token = "cus_3Ux1JsdfxOoeWa"
    user = Fabricate(:user, customer_token: customer_token)
    post '/stripe_events', event_data

    expect(Payment.first.user).to eq(user) 
  end

  it "store amount in payment model object", :vcr do
    customer_token = "cus_3Ux1JsdfxOoeWa"
    user = Fabricate(:user, customer_token: customer_token)
    post '/stripe_events', event_data

    expect(Payment.first.amount).to eq(999)    
  end

  it "create payments with reference_id", :vcr do
    customer_token = "cus_3Ux1JsdfxOoeWa"
    user = Fabricate(:user, customer_token: customer_token)
    post '/stripe_events', event_data

    expect(Payment.first.reference_id).to eq("ch_103Ux1225BGP9bWCBw5lSZ8R")
  end
end