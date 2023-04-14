require 'rails_helper'

RSpec.describe 'new_admin_merchant', type: :feature do
  describe 'As an admin, when I visit the new admin merchant page' do
    it 'I see a form that allows me to add merchant imformation' do
      visit new_admin_merchant_path

      expect(page).to have_content("New Merchant")
      expect(page).to have_content("Name:")
      expect(page).to have_field('name')
    end

    it 'I can fill out the form and click submit and see a new merchant was created with a default status of disabled' do
      visit new_admin_merchant_path

      fill_in 'name', with: 'Zonkos Joke Shop'
      click_button 'Submit'

      expect(current_path).to eq(admin_merchants_path)
      within("div#enabled_merchants") do
        expect(page).to_not have_link('Zonkos Joke Shop')
      end

      within("div#disabled_merchants") do
        expect(page).to have_link('Zonkos Joke Shop')
      end

      click_link 'Create New Merchant'

      fill_in 'name', with: 'Gladrags Wizard Wear'
      click_button 'Submit'

      expect(current_path).to eq(admin_merchants_path)
      within("div#enabled_merchants") do
        expect(page).to_not have_link('Zonkos Joke Shop')
        expect(page).to_not have_link('Gladrags Wizard Wear')
      end

      within("div#disabled_merchants") do
        expect(page).to have_link('Zonkos Joke Shop')
        expect(page).to have_link('Gladrags Wizard Wear')
      end
    end

    it 'if I enter no information it sends me back to the new merchant form with a flash message' do
      visit new_admin_merchant_path

      click_button 'Submit'
      expect(page).to have_content("Merchant Not Created: Required Information Missing")
      expect(page).to have_content("New Merchant")
      expect(page).to have_content("Name:")
      expect(page).to have_field('name')
    end
  end
end