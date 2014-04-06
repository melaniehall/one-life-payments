class Contribution < ActiveRecord::Base
	
	belongs_to :user
  
  monetize :amount_cents

  attr_writer :stripe_token
  attr_writer :stripe_currency

  attr_accessible :amount, :amount_cents, :stripe_token, :stripe_currency

  def process_payment
    charge = Stripe::Charge.create(amount: amount_cents,
                                   currency: @stripe_currency,
                                   card: @stripe_token,
                                   description: "This is the description.")
    true
  rescue Stripe::CardError
    false
  end

end
