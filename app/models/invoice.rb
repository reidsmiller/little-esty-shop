class Invoice < ApplicationRecord
  self.primary_key = :id
  validates :status, presence: true
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :invoice_items

  enum status: ['cancelled', 'in progress', 'completed']

  def self.invoice_items_not_shipped
    select('invoices.*').joins(:invoice_items).where(invoice_items: {status: ['pending', 'packaged']})
  end

  def format_time_stamp
    created_at.strftime('%A, %B %e, %Y')
  end

  def customer_full_name
  "#{customer.first_name} #{customer.last_name}"
  end

  def total_revenue
    invoice_items.joins(:item).sum('(invoice_items.quantity * items.unit_price)/ 100.0').round(2).to_s
  end

  def discounted_revenue
    sum = invoice_items
      .map(&:check_for_bulk_discounts)
      .sum
    discounted_revenue = (sum/100.0).round(2).to_s
  end

  # def discounted_revenue
  #   discounted_invoice_items_sum = invoice_items
  #     .joins(:bulk_discounts)
  #     .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
  #     .select('invoice_items.*, MAX(bulk_discounts.discount_percent) AS discount_percent')
  #     .sum('invoice_items.quantity * invoice_items.unit_price * (1 - discount_percent)/100.0')
     
  #   # undiscounted_invoice_item_sum = invoice_items
  #   #   .joins(:bulk_discounts)
  #   #   .select('invoice_items.*, MIN(bulk_discounts.quantity_threshold) AS quantity_threshold')
  #   #   .where('invoice_items.quantity < quantity_threshold')
  #   #   .sum('invoice_items.quantity * invoice_items.unit_price')
  #   # (discounted_invoice_item_sum + undiscounted_invoice_item_sum)
  # end
end