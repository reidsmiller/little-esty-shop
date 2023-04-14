require 'rails_helper'

RSpec.describe 'admin_merchants_show', type: :feature do
  describe 'As an admin, when I visit a merchants admin show page' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
    end

    it 'I see a link to update the merchants information' do
      visit admin_merchant_path(@merchant_1)
      expect(page).to have_link("Edit Merchant Info")
      visit admin_merchant_path(@merchant_2)
      expect(page).to have_link("Edit Merchant Info")
    end

    it 'when I click edit Merchant info link I am taken to a page to edit this merchant' do
      visit admin_merchant_path(@merchant_1)
      click_link("Edit Merchant Info")
      expect(current_path).to eq(edit_admin_merchant_path(@merchant_1))

      visit admin_merchant_path(@merchant_2)
      click_link("Edit Merchant Info")
      expect(current_path).to eq(edit_admin_merchant_path(@merchant_2))
    end
  end
end