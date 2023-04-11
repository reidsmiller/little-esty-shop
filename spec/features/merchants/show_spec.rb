# As a merchant,
# When I visit my merchant dashboard
# Then I see link to my merchant items index (/merchants/merchant_id/items)
# And I see a link to my merchant invoices index (/merchants/merchant_id/invoices)
require 'rails_helper'

RSpec.describe 'Merchant Dashboard/Show Page' do
  let!(:merchant) {create(:merchant)}
  describe 'displays Merchants and their most recent attributes' do
    it 'should display the name of the merchant' do
      
      visit "/merchants/#{merchant.id}/dashboard"

      expect(page).to have_content(merchant.name)
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