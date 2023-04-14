class Merchant < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def top_five_customers
    Customer.joins(invoices: [:transactions, :invoice_items => :item])  
    .select("customers.*, COUNT(result) as transactions_count")
    .group(:id)
    .where("transactions.result = ? AND items.merchant_id = ?", 1, self.id)
    .order(transactions_count: :desc).limit(5)
  end

  def unshipped_items
    Item.joins(:invoice_items)
    .select("items.*, invoice_items.status")
    .where("invoice_items.status != 2 AND items.merchant_id = ?", self.id)
  end
end