require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Spec' do 
  describe 'As a merchant when I visit my bulk discount show page' do
    before(:each) do
      @merchant = create(:merchant)
      @bulk_discount1 = BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount2 = BulkDiscount.create!(discount_percent: 0.25, quantity_threshold: 20, merchant_id: @merchant.id)
    end

    it 'I see the bulk discounts quantity threshold and percentage discount' do
      visit merchant_bulk_discount_path(@merchant, @bulk_discount1)
      expect(page).to have_content("Bulk Discount #{@bulk_discount1.id}")
      expect(page).to have_content('Discount Percent: 15.0%')
      expect(page).to have_content('Quantity Threshold: 10')

      visit merchant_bulk_discount_path(@merchant, @bulk_discount2)
      expect(page).to have_content("Bulk Discount #{@bulk_discount2.id}")
      expect(page).to have_content('Discount Percent: 25.0%')
      expect(page).to have_content('Quantity Threshold: 20')
    end
  end
end