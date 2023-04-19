require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
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


      create(:invoice_item, unit_price: 45546, quantity: 7, invoice_id: @invoice_1.id, item_id: @item_1.id, status: 'packaged')
      create(:invoice_item, unit_price: 41056, quantity: 15, invoice_id: @invoice_1.id, item_id: @item_2.id, status: 'shipped')
      create(:invoice_item, unit_price: 74241, quantity: 13, invoice_id: @invoice_2.id, item_id: @item_3.id, status: 'pending')
      create(:invoice_item, unit_price: 93564, quantity: 10, invoice_id: @invoice_2.id, item_id: @item_4.id, status: 'shipped')
      create(:invoice_item, unit_price: 31035, quantity: 19, invoice_id: @invoice_3.id, item_id: @item_5.id, status: 'pending')
      create(:invoice_item, unit_price: 65208, quantity: 11, invoice_id: @invoice_4.id, item_id: @item_6.id, status: 'packaged')
      create(:invoice_item, unit_price: 94741, quantity: 1, invoice_id: @invoice_5.id, item_id: @item_7.id, status: 'shipped')
    end

    describe '.invoice_items_not_shipped' do
      it 'returns all invoices with items not yet shipped' do
        expect(Invoice.invoice_items_not_shipped).to eq([@invoice_1, @invoice_2, @invoice_3, @invoice_4])
      end
    end

    describe '.invoice_items_not_shipped' do
      it 'returns a formatted date time' do
        expect(@invoice_1.format_time_stamp).to eq('Thursday, April 13, 2023')
        expect(@invoice_2.format_time_stamp).to eq('Wednesday, April 12, 2023')
        expect(@invoice_3.format_time_stamp).to eq('Tuesday, April 11, 2023')
        expect(@invoice_4.format_time_stamp).to eq('Monday, April 10, 2023')
      end
    end

    describe '.total_revenue' do
      it 'returns the total revenue for an invoice formatted to dollars and cents' do
        expect(@invoice_1.total_revenue).to eq("9346.62")
        expect(@invoice_2.total_revenue).to eq("19007.73")
        expect(@invoice_3.total_revenue).to eq("5896.65")
        expect(@invoice_4.total_revenue).to eq("7172.88")
        expect(@invoice_5.total_revenue).to eq("947.41")
      end
    end
    
    describe 'additional instance methods' do
      let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
      let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
      let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }

      let!(:invoice_1) { create(:invoice, customer_id: customer_1.id) }
      let!(:invoice_2) { create(:invoice, customer_id: customer_2.id) }
      let!(:invoice_3) { create(:invoice, customer_id: customer_3.id) }

      it '#customer_full_name' do
        expect(invoice_1.customer_full_name).to eq("Branden Smith")
        expect(invoice_2.customer_full_name).to eq("Reilly Robertson")
        expect(invoice_3.customer_full_name).to eq("Grace Chavez")
      end
    end
  end
end