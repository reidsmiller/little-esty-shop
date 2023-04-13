class Invoice < ApplicationRecord
  self.primary_key = :id
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  enum status: ["cancelled", "in progress", "completed"]

  def invoice_items_not_shipped
    
  end
end