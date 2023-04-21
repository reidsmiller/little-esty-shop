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

  describe 'instance methods' do
    before(:each) do
      @customers = create_list(:customer, 20)
      @merchant1 = create(:merchant)
      BulkDiscount.create!(discount_percent: 0.20, quantity_threshold: 10, merchant_id: @merchant1.id)
      @item1 = create(:item, merchant_id: @merchant1.id, unit_price: 10_000)
      @item2 = create(:item, merchant_id: @merchant1.id, unit_price: 10_000)
      @invoice1 = create(:invoice, customer_id: @customers.sample.id)
    end
    
    describe 'example 1' do
      it 'does not apply discount on items below threshold' do
        invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 5)
        invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 5)

        expect(@invoice1.total_revenue).to eq(1_000.00)
        expect(invoice_item1.discounted_revenue).to eq(500.00)
        expect(invoice_item2.discounted_revenue).to eq(500.00)
      end
    end

    describe 'example 2' do
      it 'discounts an item at threshold but not one below' do
        invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 10)
        invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 5)

        expect(@invoice1.total_revenue).to eq(1_300.00)
        expect(invoice_item1.discounted_revenue).to eq(800.00)
        expect(invoice_item2.discounted_revenue).to eq(500.00)
      end
    end

    describe 'example 3' do
      it 'chooses correct bulk discount based on threshold' do
        bulk_discount2 = BulkDiscount.create!(discount_percent: 0.30, quantity_threshold: 15, merchant_id: @merchant1.id)
        invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 12)
        invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 15)
  
        expect(@invoice1.total_revenue).to eq(2_110.00)
        expect(invoice_item1.discounted_revenue).to eq(960.00)
        expect(invoice_item2.discounted_revenue).to eq(1_050.00)
      end
    end

    describe 'example 4' do
      it 'chooses correct bulk discount based on threshold' do
        BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 15, merchant_id: @merchant1.id)
        invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 12)
        invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 15)
  
        expect(@invoice1.total_revenue).to eq(2_160.00)
        expect(invoice_item1.discounted_revenue).to eq(960.00)
        expect(invoice_item2.discounted_revenue).to eq(1_200.00)
      end
    end

    describe 'example 5' do
      it 'does not apply to a merchant or its items when it does not belong to it but is on the same invoice' do
        merchant2 = create(:merchant)
        BulkDiscount.create!(discount_percent: 0.30, quantity_threshold: 15, merchant_id: @merchant1.id)
        item3 = create(:item, merchant_id: merchant2.id, unit_price: 10_000)
        invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 10)
        invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 15)
        invoice_item3 = create(:invoice_item, invoice_id: @invoice1.id, item_id: item3.id, quantity: 15)
  
        expect(@invoice1.total_revenue).to eq(2_160.00)
        expect(invoice_item1.discounted_revenue).to eq(800.00)
        expect(invoice_item2.discounted_revenue).to eq(1_050.00)
        expect(invoice_item3.discounted_revenue).to eq(1_500.00)
      end
    end
  end
end