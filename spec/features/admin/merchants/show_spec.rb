require 'rails_helper'

RSpec.describe 'admin_merchants_show', type: :feature do
  describe 'As an admin, when I click on a merchant from the admin merchants index page' do
    it 'I am taken to that merchants admin show page and see the name of that merchant' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      visit admin_merchants_path
      expect(page).to have_link("#{merchant_1.name}")
      expect(page).to have_link("#{merchant_2.name}")

      click_link "#{merchant_1.name}"
      expect(current_path).to eq(admin_merchant_path(merchant_1))
      expect(page).to have_content("#{merchant_1.name}")

      visit admin_merchants_path
      click_link "#{merchant_2.name}"
      expect(current_path).to eq(admin_merchant_path(merchant_2))
      expect(page).to have_content("#{merchant_2.name}")
    end
  end
end