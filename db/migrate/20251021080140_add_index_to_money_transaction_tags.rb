class AddIndexToMoneyTransactionTags < ActiveRecord::Migration[7.1]
  def change
    add_index :money_transaction_tags, [:money_transaction_id, :tag_id], unique: true
  end
end
