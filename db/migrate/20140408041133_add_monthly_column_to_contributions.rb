class AddMonthlyColumnToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :monthly, :boolean
  end
end
