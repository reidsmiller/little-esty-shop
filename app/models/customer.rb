class Customer < ApplicationRecord
  self.primary_key = :id
  has_many :invoices
  has_many :items, through: :invoices
end