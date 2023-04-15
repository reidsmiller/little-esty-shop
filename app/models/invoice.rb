class Invoice < ApplicationRecord
  self.primary_key = :id
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items

  enum status: ["cancelled", "in progress", "completed"]

  def created_at_custom
    created_at.strftime("%A, %B %e, %Y")
  end
end