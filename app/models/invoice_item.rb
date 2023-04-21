class InvoiceItem < ApplicationRecord
  self.primary_key = :id
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
  has_many :transactions, through: :invoice

  enum status: ['pending', 'packaged', 'shipped']

  def format_unit_price
    (unit_price / 100.0).round(2).to_s
  end

  def items_name
    item.name
  end

  def check_for_bulk_discounts
    selected_bulk_discounts = bulk_discounts.where('quantity_threshold <= ?', quantity)
    if selected_bulk_discounts.length == 1
      discounted_price = item.unit_price - (item.unit_price * selected_bulk_discounts.first.discount_percent)
      update(unit_price: discounted_price)
    elsif selected_bulk_discounts.length > 1
      discounted_price = item.unit_price - (item.unit_price * selected_bulk_discounts.maximum(:discount_percent))
      update(unit_price: discounted_price)
    else
      update(unit_price: item.unit_price)
    end
    unit_price * quantity
  end
end