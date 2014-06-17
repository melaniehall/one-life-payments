class AddStripeIdToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :stripe_id, :string
  end
end
