class AddAttributesToContributions < ActiveRecord::Migration
  def change
  	add_column :contributions, :amount_cents, :integer
  	add_column :contributions, :user_id, :integer
    add_column :contributions, :stripe_token, :string
  end
end
