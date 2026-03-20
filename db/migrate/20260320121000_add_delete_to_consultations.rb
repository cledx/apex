class AddDeleteToConsultations < ActiveRecord::Migration[8.1]
  def change
    add_column :consultations, :deleted_at, :datetime
    add_column :consultations, :closed_at, :datetime
    add_column :consultations, :contacted_at, :datetime
  end
end
