class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|

      t.timestamps
    end
  end
end
