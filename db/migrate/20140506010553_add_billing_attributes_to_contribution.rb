class AddBillingAttributesToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :address_line1, :string
    add_column :contributions, :address_line2, :string
    add_column :contributions, :address_city, :string
    add_column :contributions, :address_state, :string
    add_column :contributions, :address_zip, :string
    add_column :contributions, :address_country, :string
  end
end
