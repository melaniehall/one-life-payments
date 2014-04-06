class Contribution < ActiveRecord::Base
	
	belongs_to :user
  
  monetize :amount_cents

  attr_writer :stripe_token
  attr_writer :stripe_currency

  attr_accessible :amount, :amount_cents, :stripe_token, :stripe_currency

  def process_payment

    if self.user.stripe_customer_id
      # they already have a subscription or have made a onetime gift.
      customer_id = self.user.stripe_customer_id

      # check our db to see if they have a subscription

      # cancel it... make a new one...



    else 
      customer = Stripe::Customer.create(
        :card => @stripe_token,
        :description => self.user.email,
        :plan => "khalpar_1000"
      )
      customer_id = customer.id

      self.user.update_attributes(:stripe_customer_id => customer_id)
    end

    # charge = Stripe::Charge.create(amount: amount_cents,
    #                                currency: @stripe_currency,
    #                                :customer => customer_id,
    #                                description: "This is the description.")
    true
  rescue Stripe::CardError
    false
  end

end
