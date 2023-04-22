class BulkDiscount < ApplicationRecord
  validates :discount_percent, presence: true
  validates :quantity_threshold, presence: true
  belongs_to :merchant
  has_many :invoice_items, through: :merchant

  def self.merchant_bulk_discounts(merchant_id)
    where(merchant_id: merchant_id)
  end

  def format_discount_percent
    (discount_percent * 100).to_s.concat('%')
  end
end