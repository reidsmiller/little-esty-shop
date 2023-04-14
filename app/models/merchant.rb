class Merchant < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :status, presence: true
  has_many :items

  enum status: ['enabled', 'disabled']
end