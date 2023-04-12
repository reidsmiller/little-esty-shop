class Customer < ApplicationRecord
  self.primary_key = :id
  has_many :invoices
  has_many :items, through: :invoices
  has_many :transactions, through: :invoices

  def self.top_5_successful_transactions
    select("customers.*, COUNT(transactions.id) AS successful_transactions_count")
      .joins(:transactions)
      .where(transactions: {result: :success})
      .group("customers.id")
      .order("successful_transactions_count DESC")
      .limit(5)
  end
end