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
      expect(page).to have_content("#{@merchant_1.name}")
      expect(page).to have_content("#{@merchant_2.name}")
      expect(page).to have_content("#{@merchant_3.name}")
      expect(page).to have_content("#{@merchant_4.name}")
    end
  end
end