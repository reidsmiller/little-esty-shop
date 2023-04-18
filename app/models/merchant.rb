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
      .order('revenue DESC, created_at DESC')
      .first
      .format_time_stamp
  end

  def top_five_customers
    Customer.joins(invoices: [:transactions, :invoice_items => :item])  
    .select("customers.*, COUNT(result) as transactions_count")
    .group(:id)
    .where("transactions.result = ? AND items.merchant_id = ?", 1, self.id)
    .order(transactions_count: :desc).limit(5)
  end

  def unshipped_items
    Item.joins(invoices: [:invoice_items])
    .select("items.*, invoices.created_at as creation_date, invoice_items.status")
    .where("invoice_items.status != 2 AND items.merchant_id = ?", self.id)
    .order(:creation_date)
  end
end