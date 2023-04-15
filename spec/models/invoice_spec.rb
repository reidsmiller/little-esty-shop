require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end

  describe 'instance methods' do
    it "#created_at_custom" do
      visit merchant_invoice_path(merchant, invoice_2.id)

      expect(page).to have_content()
    end
  end
end