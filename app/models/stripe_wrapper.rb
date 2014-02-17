module StripeWrapper 
  class Charge
    attr_reader :response, :error_message

    def initialize(options = {})
       @response = options[:response]
       @error_message = options[:error_message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
            amount: options[:amount],
            card: options[:card],
            currency: 'usd',
            description: options[:description]
          )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer 
    attr_reader :response, :error_message

    def initialize(options = {})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options = {})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: "myflix_base",
          email: options[:user][:email]
        )
        new(response: response)
      rescue Stripe::CardError => e 
        new(error_message: e.message)
      end
    end

    def self.retrieve(customer_token) 
      customer = Stripe::Customer.retrieve(customer_token)
      subscriptions = customer.subscriptions.all
    end

    def successful?
      response.present?
    end

    def customer_token
      response.id
    end

    def subscription_token
      response["subscriptions"]["data"].last.id
    end
  end
end