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

  # def total_revenue_with_discount
  #   sum = invoice_items
  #     .map(&:check_for_bulk_discounts)
  #     .sum
  #   discounted_revenue = (sum/100.0).round(2).to_s
  # end

  # def discounted_revenue
  #   invoice_items
  #     .select('invoice_items.*, MAX(bulk_discounts.discount_percent) AS max_discount_percent')
  #     .left_outer_joins(:bulk_discounts)
  #     .where('bulk_discounts.quantity_threshold <= invoice_items.quantity')
  #     .group('invoice_items.id')
  #     .sum{ |invoice_item| invoice_item.quantity * invoice_item.unit_price * invoice_item.max_discount_percent / 100.0}
  # end

  def discounted_revenue
    invoice_items
      .select('discounted_revenue')
      .from(
        invoice_items
          .select('invoice_items.*,invoice_items.quantity * invoice_items.unit_price * MAX(bulk_discounts.discount_percent) / 100.0 AS discounted_revenue')
          .joins(:bulk_discounts)
          .where('bulk_discounts.quantity_threshold <= invoice_items.quantity')
          .group('invoice_items.id'),
        :invoice_items
      )
      .sum(:discounted_revenue)
  end

  def total_revenue_with_discount
    (total_revenue.to_f - discounted_revenue).round(2).to_s
  end
end