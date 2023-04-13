class Merchant < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  has_many :items
end