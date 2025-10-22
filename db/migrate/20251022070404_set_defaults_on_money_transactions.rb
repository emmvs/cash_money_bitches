class SetDefaultsOnMoneyTransactions < ActiveRecord::Migration[7.1]
  def change
    change_column_default :money_transactions, :amount_cents, from: nil, to: 0
    change_column_default :money_transactions, :currency,     from: nil, to: "EUR"
    change_column_default :money_transactions, :receipt,      from: nil, to: false
    change_column_default :money_transactions, :eigenbeleg,   from: nil, to: false
    change_column_default :money_transactions, :reviewed,     from: nil, to: false
  end
end
