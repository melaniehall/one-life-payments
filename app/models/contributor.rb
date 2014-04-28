class Contributor < ActiveRecord::Base
  has_many :contributions
  attr_accessible :email, :first_name, :last_name, :stripe_customer_id

end
