require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).through(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of :discount_percent }
    it { should validate_presence_of :quantity_threshold }
  end

  describe 'class methods' do
    before(:each) do
      @merchant = create(:merchant)
      @bulk_discount1 = BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount2 = BulkDiscount.create!(discount_percent: 0.25, quantity_threshold: 20, merchant_id: @merchant.id)
    end

    describe '#merchant_bulk_discounts' do
      it 'returns all bulk discounts for a merchant' do
        expect(BulkDiscount.merchant_bulk_discounts(@merchant.id)).to eq([@bulk_discount1, @bulk_discount2])
      end
    end

    describe '#format_discount_percent' do
      it 'formats discount_percent' do
        expect(@bulk_discount1.format_discount_percent).to eq('15.0%')
        expect(@bulk_discount2.format_discount_percent).to eq('25.0%')
      end
    end
  end
end