class Item < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :name, numericality: false
  validates :description, presence: true
  validates :description, numericality: false
  validates :unit_price, numericality: { only_integer: true }
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def item_invoice_id_for_merchant
    invoice_items.first.invoice_id
  end

  def invoice_formatted_date
    invoice_items.first.invoice.created_at.strftime("%A, %B %e, %Y")
  end
end