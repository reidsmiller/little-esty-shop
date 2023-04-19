require 'rails_helper'

RSpec.describe 'Merchant Item Creation' do

  let!(:merchant) { create(:merchant) }

  describe 'Item creation' do
    it 'can create a new item' do
      visit new_merchant_item_path(merchant)

      fill_in("Name", with: "Rubber Ducky")
      fill_in("Description", with: "Yellow ducky toy perfect for bathtub time")
      fill_in("Unit price", with: 240483)
      click_button("Submit")
      
      expect(current_path).to eq(merchant_items_path(merchant))

      expect(page).to have_content("Rubber Ducky")
      expect(page).to have_content("Item succesfully created")
      expect(Item.find_by(name: "Rubber Ducky").status).to eq("disabled")
    end

    it 'if description is not at least 6 charachters page is redirected to new item creation form and a flash message is disaplyed' do
      visit new_merchant_item_path(merchant)

      fill_in("Name", with: "Rubber Ducky")
      fill_in("Description", with: "Duck")
      fill_in("Unit price", with: 240483)
      click_button("Submit")

      expect(current_path).to eq(new_merchant_item_path(merchant))
      expect(page).to have_content("Item not created: description has to be at least 6 charachters long")
    end
  end
end