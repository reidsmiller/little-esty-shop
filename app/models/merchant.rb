class Merchant < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :status, presence: true
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :items
  has_many :transactions, through: :invoices

  enum status: ['disabled', 'enabled']

  def self.enabled?
    where(status: :enabled)
  end

  def self.disabled?
    where(status: :disabled)
  end

  def self.top_5_merchants_by_total_revenue

    select("merchants.*, SUM(invoices SUM(invoice_items.unit_price * invoice_items.quantity)) AS total_revenue")
      .joins(:invoice_items)
      .group("merchants.id")
      .order("total_revenue DESC")
      .limit(5)
  end
end