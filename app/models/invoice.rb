class Invoice < ApplicationRecord
  self.primary_key = :id
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items

  enum status: ["cancelled", "in progress", "completed"]

  # def merchant_invoices
  #   require 'pry'; binding.pry
  #   self.pluck(:merchant_id)
  # end
end