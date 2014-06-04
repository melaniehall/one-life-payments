class Contribution < ActiveRecord::Base

  monetize :amount_cents

  attr_writer :stripe_currency

  attr_accessible :amount, :amount_cents, :stripe_token, :stripe_currency,
                  :monthly, :stripe_id, :first_name, :last_name, :email, :contributor_id,
                  :address_line1, :address_line2, :address_city, :address_state, :address_zip,
                  :address_country, :gift_designation

  validates_presence_of :email, :first_name, :last_name

  validate :process_payment

  def process_payment
    if self.monthly?
      process_monthly_gift
    else
      process_one_time_gift
    end
  end

  def process_one_time_gift
    begin
    response = Stripe::Charge.create(
      :amount => amount_cents,
      :currency => "usd",
      :description => self.email,
      :metadata => {
        :first_name => self.first_name,
        :last_name => self.last_name,
        :address_line1 => self.address_line1,
        :address_line2 => self.address_line2,
        :address_city => self.address_city,
        :address_state => self.address_state,
        :address_zip => self.address_zip,
        :address_country => self.address_country,
        :gift_designation => self.gift_designation
      },
      :card => stripe_token
    )

    save

    assign_contributor
    rescue => e
      if e.message == 'Invalid positive integer'
        errors.add('Your donation could not be processed:', "You've entered an invalid amount. Please try again.")
      else
        errors.add('Your donation could not be processed:', e.message + ". Please try again.")
      end

      false
    end
    #rescue Stripe::CardError
     # false
    #rescue Stripe::InvalidRequestError => e
     # logger.debug "************************Error: #{e.message}"
  end

  def set_customer_id stripe_token
    contributor = assign_contributor
    if contributor.stripe_customer_id
      # they already have a subscription or have made a onetime gift.
      customer_id = contributor.stripe_customer_id
    else
      customer = Stripe::Customer.create(
        :card => stripe_token,
        :description => self.email,
        :metadata => {
          :first_name => self.first_name,
          :last_name => self.last_name,
          :address_line1 => self.address_line1,
          :address_line2 => self.address_line2,
          :address_city => self.address_city,
          :address_state => self.address_state,
          :address_zip => self.address_zip,
          :address_country => self.address_country,
          :gift_designation => self.gift_designation
        }
      )

      customer_id = customer.id
      contributor.update_attributes(:stripe_customer_id => customer_id)
      customer_id
    end
  end

  def create_plan amount, name, id_name
    plan = Stripe::Plan.create(
      :amount => amount_cents,
      :interval => 'month',
      :name => name,
      :currency => 'usd',
      :id => id_name
    )
    rescue Stripe::InvalidRequestError => e
      unless e.message.include? "Plan already exists"
        raise e
      end
  end

  def create_subscription customer_id, plan_name
    customer = Stripe::Customer.retrieve(customer_id)
    customer.subscriptions.create(:plan => plan_name)
  end

  def process_monthly_gift
    begin
    amount = amount_cents
    customer_id = set_customer_id stripe_token
    name = "#{customer_id}-#{amount_in_dollars(amount_cents)}"
    id_name = name
    plan = create_plan(amount, name, id_name)
    create_subscription customer_id, name
    rescue => e
      if e.message == 'Invalid positive integer'
        errors.add('Your donation could not be processed:', "You've entered an invalid amount. Please try again.")
      else
        errors.add('Your donation could not be processed:', e.message + ". Please try again.")
      end
      false
    end
  end

  def amount_in_dollars amount_cents
    (amount_cents.to_i / 100).to_s
  end

  private

  def assign_contributor
    @contributor = Contributor.find_by_email(self.email)
    if @contributor.present?
      self.update_attributes(:contributor_id => @contributor.id)
      @contributor
    else
      @new_contributor = Contributor.create(email: self.email, first_name: self.first_name, last_name: self.last_name)
      self.update_attributes(:contributor_id => @new_contributor.id)
      @new_contributor
    end
  end

end
