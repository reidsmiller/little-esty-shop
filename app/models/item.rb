class Item < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :description, presence: true
  validates :description, length: { minimum: 6 }
  validates :unit_price, presence: true
  validates :status, presence: true
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  
  def format_unit_price
    (unit_price / 100.0).round(2).to_s
  end

  enum status: ['enabled', 'disabled']
  
  def item_invoice_id_for_merchant
    invoice_items.first.invoice_id
  end

  def invoice_formatted_date
    invoice_items.first.invoice.created_at.strftime("%A, %B %e, %Y")
  end

  def unit_price=(val)
    write_attribute :unit_price, val.to_s.gsub(/\D/, '').to_i
  end

  def format_unit_price
    (unit_price / 100.00).round(2).to_s
  end
  
  def best_selling_date
    invoice = Item.joins(invoices: :transactions)
    .where('transactions.result = ? and invoice_items.item_id = ?', "1", self.id)
    .select("invoices.*, SUM(invoice_items.unit_price * invoice_items.quantity) as total_revenue")
    .group("invoices.id")
    .order(total_revenue: :desc)
    .limit(1)
    invoice.first.created_at.strftime("%A, %B %e, %Y")
  end
end