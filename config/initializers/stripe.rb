# put below line from any begining of Stripe operations code.
Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    if user = User.where(customer_token: event.data.object.customer).first
      user.update_column(:active, true) 

      invoice = Stripe::Invoice.retrieve(event.data.object.invoice)

      Payment.create(user: user, 
        amount: invoice.lines.all.first.amount, 
        reference_id: event.data.object.id, 
        create_at: invoice.date,
        start_date: invoice.lines.all.first.period.start,
        end_date: invoice.lines.all.first.period.end,
        )
    end
  end

  events.subscribe 'charge.failed' do |event|
    user = User.where(customer_token: event.data.object.customer).first 
    user.deactivate!
  end
end