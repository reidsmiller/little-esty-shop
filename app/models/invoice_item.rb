class InvoiceItem < ApplicationRecord
  self.primary_key = :id
  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true
  belongs_to :invoice
  belongs_to :item

  enum status: ['pending', 'packaged', 'shipped']
end