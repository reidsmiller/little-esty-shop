class BulkDiscount < ApplicationRecord
  validates :discount_percent, presence: true
  validates :quantity_threshold, presence: true
  belongs_to :merchant
  has_many :invoice_items, through: :merchant
end