class Item < ApplicationRecord
  self.primary_key = :id
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def format_unit_price
    (unit_price / 100.0).round(2).to_s
  end

  def item_invoice_id_for_merchant
    invoice_items.first.invoice_id
  end

  def invoice_formatted_date
    invoice_items.first.invoice.created_at.strftime("%A, %B %e, %Y")
  end
end