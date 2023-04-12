# As a merchant,
# When I visit my merchant dashboard
# Then I see the names of the top 5 customers
# who have conducted the largest number of successful transactions with my merchant
# And next to each customer name I see the number of successful transactions they have
# conducted with my merchant
require 'rails_helper'

RSpec.describe 'Merchant Dashboard/Show Page' do
  let!(:merchant) { create(:merchant) }
  
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

  let!(:inv_1_transaction_s) { invoice_1.transactions.create(create_list(10, result: 1)) }
  let!(:inv_1_transaction_f) { invoice_1.transactions.create(create_list(:transaction, 5, result: 0)) }
  let!(:inv_2_transaction_s) { invoice_2.transactions.create(create_list(:transaction, 5, result: 1)) }
  let!(:inv_3_transaction_s) { invoice_3.transactions.create(create_list(:transaction, 7, result: 1)) }
  let!(:inv_4_transaction_s) { invoice_4.transactions.create(create_list(:transaction, 3, result: 1)) }
  let!(:inv_4_transaction_f) { invoice_4.transactions.create(create_list(:transaction, 20, result: 0)) }
  let!(:inv_5_transaction_s) { invoice_5.transactions.create(create_list(:transaction, 11, result: 1)) }
  let!(:inv_6_transaction_s) { invoice_6.transactions.create(create_list(:transaction, 8, result: 1)) }
  
  describe 'displays Merchants and their most recent attributes' do
    it 'should display the name of the merchant' do
      
      visit "/merchants/#{merchant.id}/dashboard"
      
      expect(page).to have_content(merchant.name)
    end
  end
  
  describe 'Top 5 Customers Column' do
    it 'should display the names of the top 5 customers by successful transactions in descending order' do
      visit "/merchants/#{merchant.id}/dashboard"
      require 'pry'; binding.pry
      within('#top_5_customers') do
        expect(customer_5.first_name).to appear_before(customer_1.first_name)
        expect(customer_1.first_name).to appear_before(customer_6.first_name)
        expect(customer_6.first_name).to appear_before(customer_3.first_name)
        expect(customer_3.first_name).to appear_before(customer_2.first_name)
        expect(customer_5.last_name).to appear_before(customer_1.last_name)
        expect(customer_1.last_name).to appear_before(customer_6.last_name)
        expect(customer_6.last_name).to appear_before(customer_3.last_name)
        expect(customer_3.last_name).to appear_before(customer_2.last_name)
        expect(page).to_not have_content(customer_4.first_name)
        expect(page).to_not have_content(customer_4.last_name)
      end
    end

    xit 'should display, next to the names, the number of successful transations of each top 5 customer' do

    end
  end
  describe 'displays links to merchant sub indexes' do
    it 'should display a link to merchant item index' do
      visit "/merchants/#{merchant.id}/dashboard"
      
      within('#item_index') do
      expect(page).to have_link("My Items")
      end
    end

    it 'link to merchant item index reroutes to /merchants/merchant_id/items' do
      visit "/merchants/#{merchant.id}/dashboard"

      within('#item_index') do
      click_link "My Items"

      expect(current_path).to eq(merchant_items_path(merchant))
      end
    end

    it 'should display a link to merchant invoices index' do
      visit "/merchants/#{merchant.id}/dashboard"

      within('#invoice_index') do
      expect(page).to have_link("My Invoices")
      end
    end
    
    it 'link to merchant invoice index reroutes to /merchants/merchant_id/invoices' do
      visit "/merchants/#{merchant.id}/dashboard"

      within('#invoice_index') do
      click_link "My Invoices"

      expect(current_path).to eq(merchant_invoices_path(merchant))
      end
    end
  end
end