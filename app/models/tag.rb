class Tag < ApplicationRecord
  has_many :money_transaction_tags, dependent: :destroy
  has_many :money_transactions, through: :money_transaction_tags
  validates :name, presence: true, uniqueness: true
end
