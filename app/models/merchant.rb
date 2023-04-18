class Merchant < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :status, presence: true
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  enum status: ['disabled', 'enabled']

  def self.enabled?
    where(status: :enabled)
  end

  def self.disabled?
    where(status: :disabled)
  end

  def self.top_5_merchants_by_total_revenue
    joins(invoice_items: :transactions)
      .where(transactions: {result: :success})
      .group('merchants.id')
      .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
      .order(total_revenue: :desc)
      .limit(5)
  end

  def top_selling_date
    self.invoices
      .joins(:invoice_items, :transactions)
      .where(transactions: {result: :success})
      .group('invoices.created_at')
      .select('invoices.created_at, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .order(created_at: :desc)
      .first
      .format_time_stamp
  end
end