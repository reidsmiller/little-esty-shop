require 'rails_helper'

RSpec.describe 'admin_merchants_index', type: :feature do
  describe 'As an admin, when I visit the admin merchants index' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      @merchant_4 = create(:merchant)

      visit admin_merchants_path
    end

    it 'I see the name of each merchant in the system' do
      expect(page).to have_content("Admin Merchant Index Page")
      expect(page).to have_link("#{@merchant_1.name}")
      expect(page).to have_link("#{@merchant_2.name}")
      expect(page).to have_link("#{@merchant_3.name}")
      expect(page).to have_link("#{@merchant_4.name}")
    end

    it 'when I click merchant name link I am taken to that merchants admin show page and see the name of that merchant' do
      visit admin_merchants_path

      click_link "#{@merchant_1.name}"
      expect(current_path).to eq(admin_merchant_path(@merchant_1))
      expect(page).to have_content("#{@merchant_1.name}")

      visit admin_merchants_path
      click_link "#{@merchant_2.name}"
      expect(current_path).to eq(admin_merchant_path(@merchant_2))
      expect(page).to have_content("#{@merchant_2.name}")
    end

    it 'I see a button next to each merchant to disable or enable that merchant' do
      visit admin_merchants_path
      expect(page).to button()
    end
  end
end