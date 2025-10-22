class CreateMoneyTransactionTags < ActiveRecord::Migration[7.1]
  def change
    create_table :money_transaction_tags do |t|
      t.references :money_transaction, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
