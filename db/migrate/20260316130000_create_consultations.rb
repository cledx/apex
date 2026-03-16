class CreateConsultations < ActiveRecord::Migration[8.1]
  def change
    create_table :consultations do |t|
      t.string :phone_number, null: false
      t.string :address, null: false
      t.text :details

      t.timestamps
    end
  end
end
