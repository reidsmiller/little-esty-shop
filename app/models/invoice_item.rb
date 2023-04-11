class InvoiceItem < ApplicationRecord
  self.primary_key = :id
  belongs_to :invoice
  belongs_to :item

  enum status: ['pending', 'packaged', 'shipped']
end