class Customer < ApplicationRecord
  self.primary_key = :id
  has_many :invoices
  has_many :items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :items

  def succesful_transactions
    self.transactions.where(result: 1).count
  end
end