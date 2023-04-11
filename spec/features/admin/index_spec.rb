require 'rails_helper'

RSpec.describe 'admin_dashboard', type: :feature do
  describe 'As an admin, when I visit the admin dashboard' do
    before(:each) do
      visit admin_index_path
    end

    it 'I see a header indicating that I am on the admin dashboard' do
      expect(page).to have_content('Admin Dashboard')
    end

    it 'I see a link to the admin merchants index' do
      expect(page).to have_link('Admin Merchants Index', href: admin_merchants_path)

      click_link 'Admin Merchants Index'
      expect(current_path).to eq(admin_merchants_path)
    end

    it 'I see a link to the admin invoices index' do
      expect(page).to have_link('Admin Invoices Index', href: admin_invoices_path)
      
      click_link 'Admin Invoices Index'
      expect(current_path).to eq(admin_invoices_path)
    end
  end
end