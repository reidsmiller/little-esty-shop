require 'rails_helper'

RSpec.describe 'Merchant Items Index Page' do
  let!(:merchant) { create(:merchant) }
  let!(:merchant_1) { create(:merchant) }
  
  let!(:item_1) { create(:item, name: "one", merchant_id: merchant.id, status: 0) }
  let!(:item_2) { create(:item, name: "two", merchant_id: merchant.id, status: 1) }
  let!(:item_3) { create(:item, name: "three", merchant_id: merchant.id, status: 1) }
  let!(:item_4) { create(:item, name: "four", merchant_id: merchant.id, status: 1) }
  let!(:item_5) { create(:item, name: "five", merchant_id: merchant.id, status: 1) }
  let!(:item_6) { create(:item, name: "six", merchant_id: merchant.id, status: 0) }
  let!(:item_7) { create(:item, name: "seven", merchant_id: merchant.id, status: 0) }
  let!(:item_8) { create(:item, name: "eight", merchant_id: merchant.id, status: 0) }
  let!(:item_9) { create(:item, name: "nine", merchant_id: merchant_1.id) }

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

  describe 'Display of all items' do
    it 'Displays Name of merchant' do
      visit "/merchants/#{merchant.id}/items"

      expect(page).to have_content(merchant.name)
    end

    it 'displays names of all items under this merchant within Enabled items section' do
      visit "/merchants/#{merchant.id}/items"

      within('#enabled_items') do
      
        expect(page).to have_content("Enabled Items")
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_6.name)
        expect(page).to have_content(item_7.name)
        expect(page).to have_content(item_8.name)
      end
    end

    it 'does not display names of items for other merchants' do
      visit "/merchants/#{merchant.id}/items"

      expect(page).to_not have_content(item_9.name)
    end
  end

  describe 'item name links ' do
    it "each item name is a link that redirects to it's own merchant item show page" do
      visit "/merchants/#{merchant.id}/items"
      
      within("#enabled_items") do
        expect(page).to have_link(item_1.name)
        expect(page).to have_link(item_6.name)
        expect(page).to have_link(item_7.name)
        expect(page).to have_link(item_8.name)
      end

      within("#disabled_items") do
        expect(page).to have_link(item_2.name)
        expect(page).to have_link(item_3.name)
        expect(page).to have_link(item_4.name)
        expect(page).to have_link(item_5.name)
      end

      within("#enabled_items") do
        click_link item_1.name
        expect(current_path).to eq(merchant_item_path(merchant, item_1))
        visit "/merchants/#{merchant.id}/items"
      end

      within("#disabled_items") do
        click_link item_2.name
        expect(current_path).to eq(merchant_item_path(merchant, item_2))
        visit "/merchants/#{merchant.id}/items"
      end

      within("#disabled_items") do
        click_link item_3.name
        expect(current_path).to eq(merchant_item_path(merchant, item_3))
      end
    end
  end

  describe 'disable/enable buttons for items' do
    it 'next to each item there is a button to enable/disable the item' do
      visit merchant_items_path(merchant)

      within("li#merchant_#{item_1.id}") do
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
      end

      within("li#merchant_#{item_2.id}") do
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
      end
    end

    it 'when button is clicked item status is changed and page is redirected to merchant items index' do
      visit merchant_items_path(merchant)
        
      within("li#merchant_#{item_1.id}") do
        expect(item_1.status).to eq("enabled")
        click_button "Disable"
        expect(current_path).to eq(merchant_items_path(merchant))
        expect(Item.find(item_1.id).status).to eq('disabled')
      end

      within("li#merchant_#{item_2.id}") do
        expect(item_2.status).to eq("disabled")
        click_button "Enable"
        expect(current_path).to eq(merchant_items_path(merchant))
        expect(Item.find(item_2.id).status).to eq('enabled')
      end
    end

    it 'items appear in enabled or disabled column based on their status' do
      visit merchant_items_path(merchant)

      within("#enabled_items") do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_6.name)
        expect(page).to have_content(item_7.name)
        expect(page).to have_content(item_8.name)
      end

      within("#disabled_items") do
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(item_3.name)
        expect(page).to have_content(item_4.name)
        expect(page).to have_content(item_5.name)
      end
    end

    it 'if item status is disabled then Enable button appears next to it and vise versa' do
      visit merchant_items_path(merchant)

      within("li#merchant_#{item_1.id}") do
        expect(item_1.status).to eq("enabled")
        expect(page).to have_button("Disable")
      end

      within("li#merchant_#{item_6.id}") do
        expect(item_6.status).to eq("enabled")
        expect(page).to have_button("Disable")
      end
      
      within("li#merchant_#{item_7.id}") do
        expect(item_7.status).to eq("enabled")
        expect(page).to have_button("Disable")
      end

      within("li#merchant_#{item_8.id}") do
        expect(item_8.status).to eq("enabled")
        expect(page).to have_button("Disable")
      end

      within("li#merchant_#{item_2.id}") do
        expect(item_2.status).to eq("disabled")
        expect(page).to have_button("Enable")
      end

      within("li#merchant_#{item_3.id}") do
        expect(item_3.status).to eq("disabled")
        expect(page).to have_button("Enable")
      end

      within("li#merchant_#{item_4.id}") do
        expect(item_4.status).to eq("disabled")
        expect(page).to have_button("Enable")
      end

      within("li#merchant_#{item_5.id}") do
        expect(item_5.status).to eq("disabled")
        expect(page).to have_button("Enable")
      end
    end
  end

  describe 'item_creation' do
    it 'index page shows a link to create a new item' do
      visit merchant_items_path(merchant)

      within("#item_create") do
        expect(page).to have_link("Create Item")
      end
    end

    it 'when item is clicked page is redirected to item creation form' do
      visit merchant_items_path(merchant)
      
      within("#item_create") do
        click_link "Create Item"
        expect(current_path).to eq(new_merchant_item_path(merchant))
      end
    end
  end

  describe 'top_5_items' do
    it 'dispays the top 5 items ranked by total revenue generated, but only if they have at least one succesful transaction' do
      visit merchant_items_path(merchant)

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
      visit merchant_items_path(merchant)

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
      visit merchant_items_path(merchant)

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

  describe 'Top_5_items best day' do
    it 'next to the most popular items the creation date of the invoice with the highest revenue generated is displayed' do
      visit merchant_items_path(merchant)
      
      within("li#item_#{item_6.id}") do
        expect(page).to have_content("Top day for six was Tuesday, April 18, 2023")
      end

      within("li#item_#{item_5.id}") do
        expect(page).to have_content("Top day for five was Wednesday, April 12, 2023")
      end

      within("li#item_#{item_3.id}") do
        expect(page).to have_content("Top day for three was Tuesday, April 18, 2023")
      end

      within("li#item_#{item_2.id}") do
        expect(page).to have_content("Top day for two was Tuesday, April 18, 2023")
      end

      within("li#item_#{item_1.id}") do
        expect(page).to have_content("Top day for one was Tuesday, April 18, 2023")
      end
    end
  end
end