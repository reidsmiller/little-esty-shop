require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index Page' do
  describe 'As a merchant, when I visit my discount index page' do
    before(:each) do
      @merchant = create(:merchant)
      @bulk_discount1 = BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 10, merchant_id: @merchant.id)
      @bulk_discount2 = BulkDiscount.create!(discount_percent: 0.25, quantity_threshold: 20, merchant_id: @merchant.id)
    end

    it 'I see all my bulk discounts including their percentage discount and quantity thresholds and a link to the bulk discount show page' do
      visit merchant_bulk_discounts_path(@merchant)

      expect(page).to have_content("#{@merchant.name}'s Bulk Discounts")
      expect(page).to have_link(@bulk_discount1.id.to_s)
      expect(page).to have_content('Discount Percent: 15.0%')
      expect(page).to have_content('Quantity Threshold: 10')
      expect(page).to have_link(@bulk_discount2.id.to_s)
      expect(page).to have_content('Discount Percent: 25.0%')
      expect(page).to have_content('Quantity Threshold: 20')

      click_link @bulk_discount1.id.to_s
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount1))

      visit merchant_bulk_discounts_path(@merchant)
      click_link @bulk_discount2.id.to_s
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bulk_discount2))
    end

    it 'I see a link to create a new discount, and I can click a link' do
      visit merchant_bulk_discounts_path(@merchant)

      expect(page).to have_link('Add New Bulk Discount')
      click_link 'Add New Bulk Discount'
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    end

    it 'I see next to each discount a button to delete it' do
      visit merchant_bulk_discounts_path(@merchant)

     within("li#discount_#{@bulk_discount1.id}") do
        expect(page).to have_button('Delete Discount')
        click_button 'Delete Discount'
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to_not have_link(@bulk_discount1.id.to_s)
      expect(page).to_not have_content('Discount Percent: 15.0%')
      expect(page).to_not have_content('Quantity Threshold: 10')
      expect(page).to have_link(@bulk_discount2.id.to_s)
      expect(page).to have_content('Discount Percent: 25.0%')
      expect(page).to have_content('Quantity Threshold: 20')

      within("li#discount_#{@bulk_discount2.id}") do
        expect(page).to have_button('Delete Discount')
        click_button 'Delete Discount'
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to_not have_link(@bulk_discount1.id.to_s)
      expect(page).to_not have_content('Discount Percent: 15.0%')
      expect(page).to_not have_content('Quantity Threshold: 10')
      expect(page).to_not have_link(@bulk_discount2.id.to_s)
      expect(page).to_not have_content('Discount Percent: 25.0%')
      expect(page).to_not have_content('Quantity Threshold: 20')
    end

    it 'I see a section of upcoming holidays and the next 3 upcoming US holidays are listed' do
      visit merchant_bulk_discounts_path(@merchant)
      within('#upcoming_holidays') do
        expect(page).to have_content('Upcoming Holidays')
        expect(page).to have_content('Memorial Day: 2023-05-29')
        expect(page).to have_content('Juneteenth: 2023-06-19')
        expect(page).to have_content('Independence Day: 2023-07-04')
      end
    end
  end
end