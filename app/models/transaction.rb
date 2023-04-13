class Transaction < ApplicationRecord
  self.primary_key = :id
  belongs_to :invoice
  has_one :customer, :through => :invoice

  enum result: ['failed', 'success']
end