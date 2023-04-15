
    # As a merchant,
# When I visit the merchant show page of an item
# I see a link to update the item information.
# When I click the link
# Then I am taken to a page to edit this item
# And I see a form filled in with the existing item attribute information
# When I update the information in the form and I click ‘submit’
# Then I am redirected back to the item show page where I see the updated information
# And I see a flash message stating that the information has been successfully updated.

require "rails_helper"

RSpec.describe 'Merchant Items edit page' do

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

  describe "Edit form" do
    it 'exists and has item attributes pre-filled' do
      visit edit_merchant_item_path(merchant, item_1)

      expect(page).to have_content("Edit #{item_1}'s Information:")
      expect(page).to have_content("Name:")
      expect(find_field('item_name').value).to match("#{item_1.name}")
      expect(page).to have_content("Description:")
      expect(find_field('item_description').value).to match("#{item_1.description}")
      expect(page).to have_content("Unit Price: $")
      expect(find_field('item_unit_price').value).to match("#{item_1.unit_price}")

      visit edit_merchant_item_path(merchant_1, item_9)

      expect(page).to have_content("Edit #{item_9}'s Information:")
      expect(find_field('item_name').value).to match("#{item_9.name}")
      expect(find_field('item_description').value).to match("#{item_9.description}")
      expect(find_field('item_unit_price').value).to match("#{item_9.unit_price}")
    end

    it 'when info is filled and submit button clicked page redirects to merchant item show page and I see a flash message' do
      visit edit_merchant_item_path(merchant, item_1)

      fill_in 'item_name', with: "Rubber Ducky"
      fill_in 'item_description', with: "Yellow bath tub toy that quacks"
      click_button 'Submit'

      expect(current_path).to eq(merchant_item_path(merchant, item_1))
      expect(page).to have_content("Rubber Ducky")
      expect(page).to have_content("Yellow bath tub toy that quacks")
      expect(page).to have_content("Item Information Succesfully Updated")
    end

    it 'unit_price edited by user as money amount gets converted into cent integer value' do
      visit edit_merchant_item_path(merchant_1, item_9)

      fill_in 'item_unit_price' with: "9.00"
      click_button 'Submit'

      expect(current_path).to eq(merchant_item_path(merchant_1, item_9))
      expect(item_9.unit_price).to eq(900)
      expect(page).to have_content("($9.00)")
      expect(page).to have_content("Item Information Succesfully Updated")
    end

    it 'if form is filled out with no info or incorrect data type and submit is clicked, page redirects to edit page and I see a flash error message' do
      visit edit_merchant_item_path(merchant, item_1)

      fill_in 'item_name', with: ""
      click_button 'Submit'

      expect(current_path).to eq(edit_merchant_item_path(merchant, item_1))
      expect(page).to have_content("Item not updated: Required information not filled out or filled out incorrectly")
      
      fill_in 'item_description', with: 93849
      click_button 'Submit'

      expect(current_path).to eq(edit_merchant_item_path(merchant, item_1))
      expect(page).to have_content("Item not updated: Required information not filled out or filled out incorrectly")

      fill_in 'item_unit_price', with: "I don't wana pay"
      click_button 'Submit'

      expect(current_path).to eq(edit_merchant_item_path(merchant, item_1))
      expect(page).to have_content("Item not updated: Required information not filled out or filled out incorrectly")
    end
  end
end