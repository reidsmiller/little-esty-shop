require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe '#instance methods' do
    before(:each) do
      @merchant = create(:merchant)

      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @customer_3 = create(:customer)
      @customer_4 = create(:customer)
      @customer_5 = create(:customer)
      @customer_6 = create(:customer)
      @customer_7 = create(:customer)

      @item_1 = create(:item, unit_price: 45546, merchant_id: @merchant.id)
      @item_2 = create(:item, unit_price: 41056, merchant_id: @merchant.id)
      @item_3 = create(:item, unit_price: 74241, merchant_id: @merchant.id)
      @item_4 = create(:item, unit_price: 93564, merchant_id: @merchant.id)
      @item_5 = create(:item, unit_price: 31035, merchant_id: @merchant.id)
      @item_6 = create(:item, unit_price: 65208, merchant_id: @merchant.id)
      @item_7 = create(:item, unit_price: 94741, merchant_id: @merchant.id)
      
      static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
      static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
      static_time_3 = Time.zone.parse('2023-04-11 00:50:37')
      static_time_4 = Time.zone.parse('2023-04-10 00:50:37')
      @invoice_1 = create(:invoice, status: 'in progress', customer_id: @customer_1.id, created_at: static_time_1)
      @invoice_2 = create(:invoice, status: 'in progress', customer_id: @customer_2.id, created_at: static_time_2)
      @invoice_3 = create(:invoice, status: 'in progress', customer_id: @customer_3.id, created_at: static_time_3)
      @invoice_4 = create(:invoice, status: 'in progress', customer_id: @customer_4.id, created_at: static_time_4)
      @invoice_5 = create(:invoice, status: 'in progress', customer_id: @customer_5.id)
      @invoice_6 = create(:invoice, status: 'in progress', customer_id: @customer_6.id)
      @invoice_7 = create(:invoice, status: 'in progress', customer_id: @customer_7.id)


      create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, status: 'packaged')
      create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id, status: 'shipped')
      create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_3.id, status: 'pending')
      create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_4.id, status: 'shipped')
      create(:invoice_item, invoice_id: @invoice_3.id, item_id: @item_5.id, status: 'pending')
      create(:invoice_item, invoice_id: @invoice_4.id, item_id: @item_6.id, status: 'packaged')
      create(:invoice_item, invoice_id: @invoice_5.id, item_id: @item_7.id, status: 'shipped')
    end

    describe '.format_unit_price' do
      it 'returns a formatted price in dollars' do
        expect(@item_1.format_unit_price).to eq("455.46")
        expect(@item_2.format_unit_price).to eq("410.56")
        expect(@item_3.format_unit_price).to eq("742.41")
        expect(@item_4.format_unit_price).to eq("935.64")
        expect(@item_5.format_unit_price).to eq("310.35")
        expect(@item_6.format_unit_price).to eq("652.08")
        expect(@item_7.format_unit_price).to eq("947.41")
      end
    end
  end
end