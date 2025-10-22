class AddDeductibleAndReimbursedToMoneyTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :money_transactions, :deductible, :boolean
    add_column :money_transactions, :reimbursed, :boolean
  end
end
