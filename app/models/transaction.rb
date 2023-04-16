class Transaction < ApplicationRecord
  self.primary_key = :id
  validates :credit_card_number, presence: true
  validates :result, presence: true
  belongs_to :invoice
  has_one :customer, :through => :invoice

  enum result: ['failed', 'success']
end