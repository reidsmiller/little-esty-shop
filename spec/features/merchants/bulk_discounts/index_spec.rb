require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index Page' do
  describe 'As a merchant, when I visit my discount index page' do
    before(:each) do
      @merchant = create(:merchant)
      @bulk_discount1 = create(:bulk_discount, merchant_id: @merchant.id)
      @bulk_discount2 = create(:bulk_discount, merchant_id: @merchant.id)
    end

    it 'I see all my bulk discounts including their percentage discount and quantity thresholds and a link to the bulk discount show page' do
      visit merchant_bulk_discounts_path(@merchant)

      expect(page).to have_content("#{@merchant.name}'s Bulk Discounts")
      expect(page).to have_link(@bulk_discount1.discount_percent.to_s)
      expect(page).to have_content(@bulk_discount1.quantity_threshold)
      expect(page).to have_link(@bulk_discount2.discount_percent.to_s)
      expect(page).to have_content(@bulk_discount2.quantity_threshold)

      click_link '@bulk_discount1.discount_percent.to_s'
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount1))

      visit merchant_bulk_discount_path(@merchant)
      click_link '@bulk_discount2.discount_percent.to_s'
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount2))
    end
  end
end