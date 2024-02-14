class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.integer :invoice_number
      t.integer :invoice_status
      t.date :issue_date
      t.date :due_date
      t.text :message
      t.integer :tax
      t.integer :total_amount
      t.references :company, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
