class AddTotalSalesToHouses < ActiveRecord::Migration[8.1]
  def change
    add_column :houses, :total_sales, :integer
  end
end
