class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :client_name
      t.string :client_address
      t.string :client_email
      t.string :currency

      t.timestamps
    end
  end
end
