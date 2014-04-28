class AddStripeCustomerIdToContributors < ActiveRecord::Migration
  def change
    add_column :contributors, :stripe_customer_id, :string
  end
end
