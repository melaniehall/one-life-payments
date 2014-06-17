class AddGiftDesignationToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :gift_designation, :string
  end
end
