class Merchant < ApplicationRecord
  self.primary_key = :id
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def top_five_customers
    # require 'pry'; binding.pry
    Customer.joins(:transactions)
    .select("customers.*, COUNT(result)")
    .group(:id).where("transactions.result = 1", "customers.merchants = #{@merchant}")
    .order(count: :desc).limit(5)
  end

  def unshipped_items
    # require 'pry'; binding.pry
    Item.joins(:invoice_items)
    .select("items.*, invoice_items.status")
    .where("invoice_items.status != 2", "items.merchant = #{merchant}")
  end
end