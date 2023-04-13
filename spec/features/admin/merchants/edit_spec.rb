require 'rails_helper'

RSpec.describe 'edit_admin_merchant', type: :feature do
  describe 'As an admin, when I visit an edit merchant page' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
    end

    it 'I see a form filled in with the existing merchant attribute information' do
      visit edit_admin_merchant_path(@merchant_1)
      expect(page).to have_content("Edit #{@merchant_1.name}'s Info")
      expect(page).to have_content("Name:")
      expect(find_field('name').value).to match("#{@merchant_1.name}")

      visit edit_admin_merchant_path(@merchant_2)
      expect(page).to have_content("Edit #{@merchant_2.name}'s Info")
      expect(page).to have_content("Name:")
      expect(find_field('name').value).to match("#{@merchant_2.name}")
    end

    it 'and I fill out form and click submit i am redirected back to admin merchant show page with updated info and see a flash message saying info has been successfully updated' do
      visit edit_admin_merchant_path(@merchant_1)
      fill_in 'name', with: 'Mr. Rogers'
      click_button 'Update Merchant'
      expect(current_path).to eq(admin_merchant_path(@merchant_1))
      expect(page).to have_content("Merchant Info Successfully Updated")
      expect(page).to have_content("Mr. Rogers")

      visit edit_admin_merchant_path(@merchant_2)
      fill_in 'name', with: 'Honeydukes'
      click_button 'Update Merchant'
      expect(current_path).to eq(admin_merchant_path(@merchant_1))
      expect(page).to have_content("Merchant Info Successfully Updated")
      expect(page).to have_content("Honeydukes")
    end
  end
end