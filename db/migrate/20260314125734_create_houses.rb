class CreateHouses < ActiveRecord::Migration[8.1]
  def change
    create_table :houses do |t|
      t.string :address, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :owner, null: false
      t.string :name
      t.text :description
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
