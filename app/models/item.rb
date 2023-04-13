class Item < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :description, presence: true
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
end