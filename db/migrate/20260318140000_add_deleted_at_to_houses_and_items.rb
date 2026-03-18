class AddDeletedAtToHousesAndItems < ActiveRecord::Migration[7.1]
  def change
    add_column :houses, :deleted_at, :date
    add_column :items, :deleted_at, :date
  end
end
