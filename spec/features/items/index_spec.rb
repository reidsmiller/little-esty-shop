require 'rails_helper'

RSpec.describe 'Items index page' do

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
  let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
  let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
  let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
  let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
  let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
  let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
  let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }
  let!(:inv_7_transaction_f) { create_list(:transaction, 60, result: 0, invoice_id: invoice_7.id)}


  describe "Item Index Display" do
    it 'dispays the top 5 items ranked by total revenue generated, but only if they have at least one succesful transaction' do
      visit items_path 

      within("#top_5_items") do 
          expect(page).to have_content(item_6.name)
          expect(page).to have_content(item_5.name)
          expect(page).to have_content(item_3.name)
          expect(page).to have_content(item_2.name)
          expect(page).to have_content(item_1.name)

          expect(page).to_not have_content(item_4.name)
          expect(page).to_not have_content(item_9.name)

          expect(item_6.name).to appear_before(item_5.name)
          expect(item_5.name).to appear_before(item_3.name)
          expect(item_3.name).to appear_before(item_2.name)
          expect(item_2.name).to appear_before(item_1.name)
      end
    end

    it 'each item name is a link that redirects to the mechant item show page for that item' do
      visit items_path 

      within("#top_5_items") do
        expect(page).to have_link(item_6.name)
        expect(page).to have_link(item_3.name)
        expect(page).to have_link(item_5.name)
        expect(page).to have_link(item_2.name)
        expect(page).to have_link(item_1.name)

        click_link(item_6.name)
        expect(current_path).to eq(merchant_item_path(merchant, item_6))
      end
    end

    it 'next to each item link is the total revenue generated for that item' do
      visit items_path 

      within("#top_5_items") do
        expect(page).to have_content(400000)
        expect(page).to have_content(330000)
        expect(page).to have_content(280000)
        expect(page).to have_content(62500)
        expect(page).to have_content(50000)

        expect(item_6.name).to appear_before("400000")
        expect(item_5.name).to appear_before("330000")
        expect(item_3.name).to appear_before("280000")
        expect(item_2.name).to appear_before("62500")
        expect(item_1.name).to appear_before("50000")
      end
    end
  end
end