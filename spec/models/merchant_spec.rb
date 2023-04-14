require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'instance_methods' do
    
    let!(:merchant) { create(:merchant) }
    let!(:merchant_1) { create(:merchant) }
    
    let!(:item_1) { create(:item, merchant_id: merchant.id) }
    let!(:item_2) { create(:item, merchant_id: merchant.id) }
    let!(:item_3) { create(:item, merchant_id: merchant.id) }
    let!(:item_4) { create(:item, merchant_id: merchant.id) }
    let!(:item_5) { create(:item, merchant_id: merchant.id) }
    let!(:item_6) { create(:item, merchant_id: merchant.id) }
    let!(:item_7) { create(:item, merchant_id: merchant.id) }
    let!(:item_8) { create(:item, merchant_id: merchant.id) }
    let!(:item_9) { create(:item, merchant_id: merchant_1.id) }
    let!(:item_10) { create(:item, merchant_id: merchant_1.id) }

    let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
    let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
    let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
    let!(:customer_4) { create(:customer, first_name: 'Logan', last_name: 'Nguyen') }
    let!(:customer_5) { create(:customer, first_name: 'Brandon', last_name: 'Popular') }
    let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }

    let!(:invoice_1) { customer_1.invoices.create }
    let!(:invoice_2) { customer_2.invoices.create }
    let!(:invoice_3) { customer_3.invoices.create }
    let!(:invoice_4) { customer_4.invoices.create }
    let!(:invoice_5) { customer_5.invoices.create }
    let!(:invoice_6) { customer_6.invoices.create }
    let!(:invoice_7) { customer_6.invoices.create }
    let!(:invoice_8) { customer_6.invoices.create }

    let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2) }
    let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2) }
    let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2) }
    let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 0) }
    let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 0) }
    let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id, status: 1) }
    let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1) }
    let!(:invoice_item_8) { create(:invoice_item, item_id: item_10.id, invoice_id: invoice_8.id, status: 1) }

    let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
    let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
    let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
    let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
    let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
    let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
    let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
    let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }
    let!(:inv_7_transaction_s) { create_list(:transaction, 20, result: 1, invoice_id: invoice_8.id) }
    
    describe '#top_five_customers' do
      it '#customers retrieves five customers with the highest number of successful transactions from highest to lowest' do
        expect(merchant.top_five_customers).to eq([customer_5, customer_1, customer_6, customer_3, customer_2])
      end
    end

    describe '#unshipped_items' do
      it 'retrieves items from this merchant that have an order and that order status is not shipped' do
        # require 'pry'; binding.pry
        expect(merchant.unshipped_items).to eq([item_4, item_5, item_6])
      end
    end
  end
end