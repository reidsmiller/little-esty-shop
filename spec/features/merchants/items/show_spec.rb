require 'rails_helper'

RSpec.describe 'Merchant Items show Page' do

  let!(:merchant) { create(:merchant) }
  let!(:merchant_1) { create(:merchant) }
  
  let!(:item_1) { create(:item, merchant_id: merchant.id, description: "Faker is actually really annoying when it creates the same data between multiple objects!!!") }
  let!(:item_2) { create(:item, merchant_id: merchant.id) }
  let!(:item_3) { create(:item, merchant_id: merchant.id) }
  let!(:item_4) { create(:item, merchant_id: merchant.id) }
  let!(:item_5) { create(:item, merchant_id: merchant.id) }
  let!(:item_6) { create(:item, merchant_id: merchant.id) }
  let!(:item_7) { create(:item, merchant_id: merchant.id) }
  let!(:item_8) { create(:item, merchant_id: merchant.id) }
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

  let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2) }
  let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2) }
  let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2) }
  let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 0) }
  let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 0) }
  let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id, status: 1) }
  let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1) }

  let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
  let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
  let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
  let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
  let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
  let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
  let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
  let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }

  describe 'Page Display' do
    it 'Displays name of merchant selling this item' do
      visit merchant_item_path(merchant, item_1)

      expect(page).to have_content(merchant.name)
    end

    it "displays attributes of item and not of other items" do
      visit merchant_item_path(merchant, item_1)
      
      within("#item_name") do
        expect(page).to have_content(item_1.name)
        expect(page).to_not have_content(item_2.name)
      end

      within("#item_attributes") do
        expect(page).to have_content(item_1.description)
        expect(page).to have_content(item_1.format_unit_price)

        expect(page).to_not have_content(item_3.description)
        expect(page).to_not have_content(item_4.format_unit_price)
      end
    end

    it 'link to update item exists and redirects to page to edit item' do
      visit merchant_item_path(merchant, item_1)

      within("#update_item") do
      expect(page).to have_link("Update Item")
      click_link("Update Item")

      expect(current_path).to eq(edit_merchant_item_path(merchant, item_1))
      end
    end
  end
end