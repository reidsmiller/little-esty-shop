# As a merchant,
# When I visit my merchant's invoices index (/merchants/merchant_id/invoices)
# Then I see all of the invoices that include at least one of my merchant's items
# And for each invoice I see its id
# And each id links to the merchant invoice show page

require 'rails_helper'

RSpec.describe 'Merchant/invoices index page' do
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

  let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
  let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
  let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
  let!(:customer_4) { create(:customer, first_name: 'Logan', last_name: 'Nguyen') }
  let!(:customer_5) { create(:customer, first_name: 'Brandon', last_name: 'Popular') }
  let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }
  let!(:customer_8) { create(:customer, first_name: 'Billy', last_name: 'Joel') }

  let!(:invoice_1) { customer_1.invoices.create }
  let!(:invoice_2) { customer_2.invoices.create }
  let!(:invoice_3) { customer_3.invoices.create }
  let!(:invoice_4) { customer_4.invoices.create }
  let!(:invoice_5) { customer_5.invoices.create }
  let!(:invoice_6) { customer_6.invoices.create }
  let!(:invoice_7) { customer_8.invoices.create }

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
  
  describe 'invoice items, ids, and id_links' do
    it 'should display invoices associated with each merchant' do
      visit merchant_invoices_path(merchant)

      expect(page).to have_content(invoice_1.id)
      expect(page).to have_content(invoice_2.id)
      expect(page).to have_content(invoice_3.id)
      expect(page).to have_content(invoice_4.id)
      expect(page).to have_content(invoice_5.id)
      expect(page).to have_content(invoice_6.id)
      expect(page).to_not have_content(invoice_7.id)
    end
    
    it 'should display invoice ids associated with merchant as links to merchant/invoices show page' do
      visit merchant_invoices_path(merchant)
      
      within "#invoices" do
        expect(page).to have_link("#{invoice_1.id}")
        expect(page).to have_link("#{invoice_2.id}")
        expect(page).to have_link("#{invoice_3.id}")
        expect(page).to have_link("#{invoice_4.id}")
        expect(page).to have_link("#{invoice_5.id}")
        expect(page).to have_link("#{invoice_6.id}")
        expect(page).to_not have_link("#{invoice_7.id}")
        
        click_link("#{invoice_1.id}")
        
        expect(current_path).to eq(merchant_invoice_path(merchant, invoice_1.id))
      end
      
      visit merchant_invoices_path(merchant)

      within "#invoices" do
        click_link("#{invoice_2.id}")

        expect(current_path).to eq(merchant_invoice_path(merchant, invoice_2.id))
      end
    end
  end
end