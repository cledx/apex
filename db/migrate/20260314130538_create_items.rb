class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.string :tags, array: true, default: []
      t.text :description
      t.string :condition
      t.string :age
      t.string :category, index: true
      t.references :house, null: false, foreign_key: true

      t.timestamps
    end
  end
end
