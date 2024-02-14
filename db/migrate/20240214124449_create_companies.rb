class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :company_info
      t.string :company_address
      t.text :bank_details
      t.integer :vat_number
      t.integer :tax_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
