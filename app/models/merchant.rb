class Merchant < ApplicationRecord
  self.primary_key = :id
  validates :name, presence: true
  validates :status, presence: true
  has_many :items

  enum status: ['disabled', 'enabled']

  def self.enabled?
    where(status: :enabled)
  end

  def self.disabled?
    where(status: :disabled)
  end
end