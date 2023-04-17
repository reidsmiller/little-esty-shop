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

      @item_1 = create(:item, merchant_id: @merchant.id)
      @item_2 = create(:item, merchant_id: @merchant.id)
      @item_3 = create(:item, merchant_id: @merchant.id)
      @item_4 = create(:item, merchant_id: @merchant.id)
      @item_5 = create(:item, merchant_id: @merchant.id)
      @item_6 = create(:item, merchant_id: @merchant.id)
      @item_7 = create(:item, merchant_id: @merchant.id)
      
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
    
    describe 'additional instance methods' do
      let!(:merchant) { create(:merchant) }

      let!(:item_1) { create(:item, merchant_id: merchant.id, name: "Grandaddy Purple") }
      let!(:item_2) { create(:item, merchant_id: merchant.id, name: "Girl Scout Cookies") }
      let!(:item_3) { create(:item, merchant_id: merchant.id, name: "OG Kush") }

      let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
      let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
      let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }

      static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
      static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
      static_time_3 = Time.zone.parse('2023-04-15 00:50:37')

      let!(:invoice_1) { create(:invoice, customer_id: customer_1.id, created_at: static_time_1) }
      let!(:invoice_2) { create(:invoice, customer_id: customer_2.id, created_at: static_time_2) }
      let!(:invoice_3) { create(:invoice, customer_id: customer_3.id, created_at: static_time_3) }
      
      let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, unit_price: 6000, quantity: 3) }
      let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2, unit_price: 1000, quantity: 12) }
      let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2) }
      let!(:invoice_item_4) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_2.id, status: 2, unit_price: 8800, quantity: 10) }

      it '#customer_full_name' do
        expect(invoice_1.customer_full_name).to eq("Branden Smith")
        expect(invoice_2.customer_full_name).to eq("Reilly Robertson")
        expect(invoice_3.customer_full_name).to eq("Grace Chavez")
      end

      it '#total_revenue' do
        expect(invoice_1.total_revenue).to eq("180.0")
        expect(invoice_2.total_revenue).to eq("1000.0")
      end
    end
  end
end