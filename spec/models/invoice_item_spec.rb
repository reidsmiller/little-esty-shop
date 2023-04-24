require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant)}
    it { should have_many(:transactions).through(:invoice) }
  end

  describe 'Instance Methods' do
    describe 'merchant items' do
      let!(:merchant) { create(:merchant) }
      let!(:merchant_1) { create(:merchant) }

      let!(:item_1) { create(:item, merchant_id: merchant.id, name: "Grandaddy Purple") }
      let!(:item_2) { create(:item, merchant_id: merchant.id, name: "Girl Scout Cookies") }
      let!(:item_3) { create(:item, merchant_id: merchant.id, name: "OG Kush") }
      let!(:item_9) { create(:item, merchant_id: merchant_1.id) }

      let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
      let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
      let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
      let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }

      static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
      static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
      static_time_3 = Time.zone.parse('2023-04-15 00:50:37')

      let!(:invoice_1) { create(:invoice, customer_id: customer_1.id, created_at: static_time_1) }
      let!(:invoice_2) { create(:invoice, customer_id: customer_2.id, created_at: static_time_2) }
      let!(:invoice_3) { create(:invoice, customer_id: customer_3.id, created_at: static_time_3) }
      let!(:invoice_7) { create(:invoice, customer_id: customer_6.id) }

      let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, unit_price: 40001) }
      let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2) }
      let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2) }
      let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1, unit_price: 12345) }

      it '#format_unit_price' do
        expect(invoice_item_1.format_unit_price).to eq("400.01")
        expect(invoice_item_7.format_unit_price).to eq("123.45")
      end

      it '#items_name' do
        expect(invoice_item_1.items_name).to eq("Grandaddy Purple")
        expect(invoice_item_2.items_name).to eq("Girl Scout Cookies")
        expect(invoice_item_3.items_name).to eq("OG Kush")
      end
    end

    describe '#discounted_revenue' do
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

          expect(invoice_item1.check_for_bulk_discounts).to eq(50_000)
          expect(invoice_item2.check_for_bulk_discounts).to eq(50_000)
        end
      end

      describe 'example 2' do
        it 'discounts an item at threshold but not one below' do
          invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 10)
          invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 5)

          expect(invoice_item1.check_for_bulk_discounts).to eq(80_000)
          expect(invoice_item2.check_for_bulk_discounts).to eq(50_000)
        end
      end

      describe 'example 3' do
        it 'chooses correct bulk discount based on threshold' do
          BulkDiscount.create!(discount_percent: 0.30, quantity_threshold: 15, merchant_id: @merchant1.id)
          invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 12)
          invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 15)

          expect(invoice_item1.check_for_bulk_discounts).to eq(96_000)
          expect(invoice_item2.check_for_bulk_discounts).to eq(105_000)
        end
      end

      describe 'example 4' do
        it 'will not choose a bulk discount with less discount percent but higher threshold' do
          BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 15, merchant_id: @merchant1.id)
          invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, quantity: 12)
          invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, quantity: 15)

          expect(invoice_item1.check_for_bulk_discounts).to eq(96_000)
          expect(invoice_item2.check_for_bulk_discounts).to eq(120_000)
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

          expect(invoice_item1.check_for_bulk_discounts).to eq(80_000)
          expect(invoice_item2.check_for_bulk_discounts).to eq(105_000)
          expect(invoice_item3.check_for_bulk_discounts).to eq(150_000)
        end
      end
    end
  end
end