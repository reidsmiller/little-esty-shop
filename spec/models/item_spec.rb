require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description) }
  end

  describe 'instance_methods' do
    let!(:merchant) { create(:merchant) }
    let!(:merchant_1) { create(:merchant) }
    
    let!(:item_1) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_2) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_3) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_4) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_5) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_6) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_7) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_8) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_9) { create(:item, merchant_id: merchant_1.id) }
  
    let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
    let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
    let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
    let!(:customer_4) { create(:customer, first_name: 'Logan', last_name: 'Nguyen') }
    let!(:customer_5) { create(:customer, first_name: 'Brandon', last_name: 'Popular') }
    let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }
  
    static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
    static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
  
    let!(:invoice_1) { create(:invoice, customer_id: customer_1.id) }
    let!(:invoice_2) { create(:invoice, customer_id: customer_2.id) }
    let!(:invoice_3) { create(:invoice, customer_id: customer_3.id) }
    let!(:invoice_4) { create(:invoice, customer_id: customer_4.id, created_at: static_time_1) }
    let!(:invoice_5) { create(:invoice, customer_id: customer_5.id, created_at: static_time_2) }
    let!(:invoice_6) { create(:invoice, customer_id: customer_6.id) }
    let!(:invoice_7) { create(:invoice, customer_id: customer_6.id) }
  
    let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, unit_price: 1000, quantity: 5) }
    let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2, unit_price: 500, quantity: 25) }
    let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2, unit_price: 10000, quantity: 4) }
    let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 0, unit_price: 1000, quantity: 10) }
    let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 0, unit_price: 500, quantity: 60) }
    let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id, status: 1, unit_price: 5000, quantity: 10) }
    let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1, unit_price: 10000, quantity: 20) }
  
    let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
    let!(:inv_1_transaction_f) { create_list(:transaction, 10, result: 0, invoice_id: invoice_1.id) }
    let!(:inv_2_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_2.id) }
    let!(:inv_3_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_3.id) }
    let!(:inv_4_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_4.id) }
    let!(:inv_4_transaction_f) { create_list(:transaction, 10, result: 0, invoice_id: invoice_4.id) }
    let!(:inv_5_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_5.id) }
    let!(:inv_6_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_6.id) }
    let!(:inv_7_transaction_f) { create_list(:transaction, 60, result: 0, invoice_id: invoice_7.id)}
  
    describe 'item_invoice_id' do
      it 'locates the id of the invoice joined to this item through invoice_items for a partcular merchant' do
        expect(item_4.item_invoice_id_for_merchant).to eq(invoice_4.id)
        expect(item_5.item_invoice_id_for_merchant).to eq(invoice_5.id)
      end
    end

    describe 'invoice_formatted_date' do
      it 'formats the creation_at date to be like "Thursday, April 13, 2023"' do
        expect(item_4.invoice_formatted_date).to eq('Thursday, April 13, 2023')
        expect(item_5.invoice_formatted_date).to eq('Wednesday, April 12, 2023')
      end
    end

    describe 'unit_price=(val) method' do
      it 'formats unit price from user input from string to number' do
        expect("$20.39".to_s.gsub(/\D/, '').to_i).to eq(2039)
        expect("$%^93802".to_s.gsub(/\D/, '').to_i).to eq(93802)
        expect("(#)$*@0982&^%".to_s.gsub(/\D/, '').to_i).to eq(982)
      end
    end

    describe '.best_selling_date' do
      let!(:invoice_8) { create(:invoice, customer_id: customer_4.id, created_at: static_time_1) }
      let!(:invoice_9) { create(:invoice, customer_id: customer_5.id, created_at: static_time_2) }

      let!(:invoice_item_8) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_8.id, status: 1, unit_price: 5000000, quantity: 10) }
      let!(:invoice_item_9) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_9.id, status: 1, unit_price: 10000000, quantity: 20) }
      
      let!(:inv_8_transaction_s) { create_list(:transaction, 1, result: 1, invoice_id: invoice_8.id) }
      let!(:inv_9_transaction_s) { create_list(:transaction, 1, result: 1, invoice_id: invoice_9.id)}

      let!(:invoice_10) { create(:invoice, customer_id: customer_4.id, created_at: static_time_1) }
      let!(:invoice_11) { create(:invoice, customer_id: customer_5.id, created_at: static_time_2) }

      let!(:invoice_item_10) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_10.id, status: 1, unit_price: 5000000, quantity: 10) }
      let!(:invoice_item_11) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_11.id, status: 1, unit_price: 5000000, quantity: 10) }
      
      let!(:inv_10_transaction_s) { create_list(:transaction, 1, result: 1, invoice_id: invoice_10.id) }
      let!(:inv_11_transaction_s) { create_list(:transaction, 1, result: 1, invoice_id: invoice_11.id) }
      
      it "provides the formatted date of the item's highest revenue sales day by invoice creation date" do
        expect(item_1.best_selling_date).to eq("Wednesday, April 12, 2023")
      end

      it 'if there are multiple invoices with equal number of sales the most recent date is returned' do
        expect(item_2.best_selling_date).to eq("Thursday, April 13, 2023")
      end
    end
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
