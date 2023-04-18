class Invoice < ApplicationRecord
  self.primary_key = :id
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  enum status: ['cancelled', 'in progress', 'completed']

  def self.invoice_items_not_shipped
    select('invoices.*').joins(:invoice_items).where(invoice_items: {status: ['pending', 'packaged']})
  end

  def format_time_stamp
    created_at.strftime('%A, %B %e, %Y')
  end

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def format_total_revenue
    (total_revenue/ 100.0).round(2).to_s
  end
end