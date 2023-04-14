class Item < ApplicationRecord
  self.primary_key = :id
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def item_invoice_id_for_merchant
    invoice_items.first.invoice_id
  end
end