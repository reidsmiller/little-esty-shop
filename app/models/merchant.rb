class Merchant < ApplicationRecord
  self.primary_key = :id
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def top_five_customers
    Customer.joins(:transactions).select("customers.*, COUNT(result)").group(:id).where("transactions.result = 1", "customers.merchants = #{@merchant}").order(count: :desc).limit(5)
  end
end