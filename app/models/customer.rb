class Customer < ApplicationRecord
  self.primary_key = :id
  has_many :invoices
  has_many :items, through: :invoices
  has_many :transactions, through: :invoices

  def self.top_5_successful_trans
    
  end

  def success_transaction_count
    transactions.where(result: :success).size
  end
end