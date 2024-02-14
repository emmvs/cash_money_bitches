class Company < ApplicationRecord
  belongs_to :user

  has_many :clients
  # has_many :expenses
  # has_many :invoices
end
