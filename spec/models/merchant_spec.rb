require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'instance_methods' do
    describe '#top_five_customers' do

    let!(:merchant) { create(:merchant) }
  
    let!(:item_1) { create(:item, merchant_id: merchant.id) }
    let!(:item_2) { create(:item, merchant_id: merchant.id) }
    let!(:item_3) { create(:item, merchant_id: merchant.id) }
    let!(:item_4) { create(:item, merchant_id: merchant.id) }
    let!(:item_5) { create(:item, merchant_id: merchant.id) }
    let!(:item_6) { create(:item, merchant_id: merchant.id) }
  
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
  
    let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id) }
    let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id) }
    let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id) }
    let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id) }
    let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id) }
    let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id) }
  
    let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
    let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
    let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
    let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
    let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
    let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
    let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
    let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }

      it 'retrieves five customers with the highest number of successful transactions from highest to lowest' do
        expect(merchant.top_five_customers).to eq([customer_5, customer_1, customer_6, customer_3, customer_2])
      end
    end
  end
end