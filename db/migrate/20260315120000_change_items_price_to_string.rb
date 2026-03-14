class ChangeItemsPriceToString < ActiveRecord::Migration[8.0]
  def up
    change_column :items, :price, :string
  end

  def down
    change_column :items, :price, :decimal, precision: 10, scale: 2
  end
end
