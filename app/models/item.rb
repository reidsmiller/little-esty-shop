class Item < ApplicationRecord
  self.primary_key = :id
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def format_unit_price
    (unit_price / 100.0).round(2).to_s
  end
end