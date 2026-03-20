class AddClientNameAndEmailToConsultations < ActiveRecord::Migration[8.1]
  def change
    add_column :consultations, :client_name, :string, null: false, default: ""
    add_column :consultations, :email, :string, null: false, default: ""
  end
end
