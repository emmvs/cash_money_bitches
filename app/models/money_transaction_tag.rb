class MoneyTransactionTag < ApplicationRecord
  belongs_to :money_transaction
  belongs_to :tag
  validates :money_transaction_id, uniqueness: { scope: :tag_id }
end
