module StripeWrapper 
  class Charge
    def self.create(options = {})
      Stripe::Charge.create(
          amount: options[:amount],
          card: options[:card],
          currency: 'usd',
          description: options[:description]
        )
    end
  end
end