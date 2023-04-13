require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end

  describe '#instance methods' do
    before(:each) do
      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @customer_3 = create(:customer)
      @customer_4 = create(:customer)
      @customer_5 = create(:customer)
      @customer_6 = create(:customer)
      @customer_7 = create(:customer)

      @item_1: create(:item)
      @item_2: create(:item)
      @item_3: create(:item)
      @item_4: create(:item)
      @item_5: create(:item)
      @item_6: create(:item)
      @item_7: create(:item)
      
      @invoice_1 = create(:invoice, status: 'in progress', customer_id: @customer_1.id)
      @invoice_2 = create(:invoice, status: 'in progress', customer_id: @customer_2.id)
      @invoice_3 = create(:invoice, status: 'in progress', customer_id: @customer_3.id)
      @invoice_4 = create(:invoice, status: 'in progress', customer_id: @customer_4.id)
      @invoice_5 = create(:invoice, status: 'in progress', customer_id: @customer_5.id)
      @invoice_6 = create(:invoice, status: 'in progress', customer_id: @customer_6.id)
      @invoice_7 = create(:invoice, status: 'in progress', customer_id: @customer_7.id)


      create(:invoice_item, invoice_id: @invoice_1, item_id: @item_1.id, status: 'packaged')
      create(:invoice_item, invoice_id: @invoice_1, item_id: @item_2.id, status: 'shipped')
      create(:invoice_item, invoice_id: @invoice_2, item_id: @item_3.id, status: 'pending')
      create(:invoice_item, invoice_id: @invoice_2, item_id: @item_4.id, status: 'shipped')
      create(:invoice_item, invoice_id: @invoice_3, item_id: @item_5.id, status: 'pending')
      create(:invoice_item, invoice_id: @invoice_4, item_id: @item_6.id, status: 'packaged')
      create(:invoice_item, invoice_id: @invoice_5, item_id: @item_7.id, status: 'shipped')
    end

    describe '.invoice_items_not_shipped' do
      it 'returns all invoices with items not yet shipped' do
        expect(Invoice.invoice_items_not_shipped).to eq([@invoice_1, @invoice_2, @invoice_3, @invoice_4])
      end
    end
  end
end