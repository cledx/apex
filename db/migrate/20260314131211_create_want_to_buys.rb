class CreateWantToBuys < ActiveRecord::Migration[8.1]
  def change
    create_table :want_to_buys do |t|
      t.references :item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
