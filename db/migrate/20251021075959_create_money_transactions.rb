class CreateMoneyTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :money_transactions do |t|
      t.string :external_id
      t.date :date
      t.text :description
      t.integer :amount_cents
      t.string :currency
      t.string :direction
      t.string :source_file
      t.string :raw_tags
      t.string :elster_bucket
      t.boolean :is_business
      t.boolean :receipt
      t.boolean :eigenbeleg
      t.boolean :reviewed

      t.timestamps
    end
  end
end
