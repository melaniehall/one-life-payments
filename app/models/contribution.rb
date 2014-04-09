class Contribution < ActiveRecord::Base

	belongs_to :user

  monetize :amount_cents

  attr_writer :stripe_token
  attr_writer :stripe_currency

  attr_accessible :amount, :amount_cents, :stripe_token, :stripe_currency, :monthly

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
        :plan => "khalpar_50"
      )
      customer_id = customer.id

      self.user.update_attributes(:stripe_customer_id => customer_id)
    end
    true
  rescue Stripe::CardError
    false
  end

  def process_one_time_gift
    if self.user.stripe_customer_id
      # they already have a subscription or have made a onetime gift.
      customer_id = self.user.stripe_customer_id
    else
      customer_id = customer.id
      self.user.update_attributes(:stripe_customer_id => customer_id)
    end
    charge = Stripe::Charge.create(amount: amount_cents,
                                   currency: @stripe_currency,
                                   :customer => customer_id,
                                   description: "This is the description.")
    true
    rescue Stripe::CardError
      false
  end

  def set_customer_id
    if self.user.stripe_customer_id
      # they already have a subscription or have made a onetime gift.
      customer_id = self.user.stripe_customer_id
    else
      customer_id = customer.id
      self.user.update_attributes(:stripe_customer_id => customer_id)
    end
  end

  def create_plan amount, name, id_name
    Stripe::Plan.create(
      :amount => amount_cents,
      :interval => 'month',
      :name => name,
      :currency => 'usd',
      :id => id_name
    )
  end

  def create_plan_and_process_payment
    amount = amount_cents
    customer_id = set_customer_id
    name = "#{customer_id} + #{amount_cents}"
    id_name = name
    create_plan(amount, name, id_name)
      customer = Stripe::Customer.create(
        :card => @stripe_token,
        :description => self.user.email,
        :plan => name
      )

    rescue Stripe::CardError
      false
  end

end
