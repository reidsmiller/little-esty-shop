require 'rails_helper'

RSpec.describe 'New Merchant Bulk Discount Page', type: :feature do
  describe 'As a merchant when I visit a new bulk discout page' do
    before(:each) do
      @merchant = create(:merchant)
      @bulk_discount1 = BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount2 = BulkDiscount.create!(discount_percent: 0.25, quantity_threshold: 20, merchant_id: @merchant.id)
    end

    it 'I see a form to add a new bulk discount' do
      visit new_merchant_bulk_discount_path(@merchant)

      expect(page).to have_content('New Bulk Discount')
      expect(page).to have_content('Discount Percent:')
      expect(page).to have_field('bulk_discount[discount_percent]')
      expect(page).to have_content('Quantity Threshold:')
      expect(page).to have_field('bulk_discount[quantity_threshold]')
      expect(page).to have_button('Create Bulk discount')
    end

    it 'I fill in the form with valid data I am redirected to the bulk discount index and I see my new bulk discount listed' do
      visit new_merchant_bulk_discount_path(@merchant)

      fill_in 'bulk_discount[discount_percent]', with: 0.30
      fill_in 'bulk_discount[quantity_threshold]', with: 30
      click_button 'Create Bulk discount'

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to have_content('Discount Successfully Created')
      expect(page).to have_content('Discount Percent: 30.0%')
      expect(page).to have_content('Quantity Threshold: 30')
    end

    it 'I fill in the form with invalid data it returns me to form with a message' do
      visit new_merchant_bulk_discount_path(@merchant)

      fill_in 'bulk_discount[discount_percent]', with: 'thirty'
      fill_in 'bulk_discount[quantity_threshold]', with: 'mag'
      click_button 'Create Bulk discount'

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
      expect(page).to have_content('Discount Not Created: Invalid Input')

      visit new_merchant_bulk_discount_path(@merchant)

      fill_in 'bulk_discount[discount_percent]', with: ''
      fill_in 'bulk_discount[quantity_threshold]', with: ''
      click_button 'Create Bulk discount'

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
      expect(page).to have_content('Discount Not Created: Invalid Input')
    end
  end
end