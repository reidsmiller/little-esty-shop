require 'rails_helper'

RSpec.describe 'Edit Merchant Bulk Discount Page', type: :feature do
  describe 'As a merchant, when I visit the edit page' do
    before(:each) do
      @merchant = create(:merchant)
      @bulk_discount1 = BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount2 = BulkDiscount.create!(discount_percent: 0.25, quantity_threshold: 20, merchant_id: @merchant.id)
    end

    it 'I see a form to edit the discount with prepopulated current attributes' do
      visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount1)

      expect(page).to have_content("Edit Bulk Discount #{@bulk_discount1.id}")
      expect(page).to have_content('Discount Percent:')
      expect(find_field('bulk_discount[discount_percent]').value).to eq(@bulk_discount1.discount_percent.to_s)
      expect(page).to have_content('Quantity Threshold:')
      expect(find_field('bulk_discount[quantity_threshold]').value).to eq(@bulk_discount1.quantity_threshold.to_s)
      expect(page).to have_button('Update Bulk discount')

      visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount2)

      expect(page).to have_content("Edit Bulk Discount #{@bulk_discount2.id}")
      expect(page).to have_content('Discount Percent:')
      expect(find_field('bulk_discount[discount_percent]').value).to eq(@bulk_discount2.discount_percent.to_s)
      expect(page).to have_content('Quantity Threshold:')
      expect(find_field('bulk_discount[quantity_threshold]').value).to eq(@bulk_discount2.quantity_threshold.to_s)
      expect(page).to have_button('Update Bulk discount')
    end

    it 'I can change any of the information and Im redirected to discount show page with updated info' do
      visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount1)

      fill_in 'bulk_discount[discount_percent]', with: 0.16
      click_button 'Update Bulk discount'
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount1))
      expect(page).to have_content('Discount Successfully Updated')
      expect(page).to have_content('Discount Percent: 16.0%')
      expect(page).to have_content('Quantity Threshold: 10')

      visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount2)

      fill_in 'bulk_discount[discount_percent]', with: 0.30
      fill_in 'bulk_discount[quantity_threshold]', with: 25
      click_button 'Update Bulk discount'
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount2))
      expect(page).to have_content('Discount Successfully Updated')
      expect(page).to have_content('Discount Percent: 30.0%')
      expect(page).to have_content('Quantity Threshold: 25')
    end

    it 'if I fill in incorrect info I am returned to edit page with message' do
      visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount1)

      fill_in 'bulk_discount[discount_percent]', with: 'Frankfurt'
      click_button 'Update Bulk discount'
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bulk_discount1))
      expect(page).to have_content('Unable to Update: Invalid Input')

      visit edit_merchant_bulk_discount_path(@merchant, @bulk_discount2)

      fill_in 'bulk_discount[discount_percent]', with: ''
      fill_in 'bulk_discount[quantity_threshold]', with: 25
      click_button 'Update Bulk discount'
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bulk_discount2))
      expect(page).to have_content('Unable to Update: Invalid Input')
    end
  end
end