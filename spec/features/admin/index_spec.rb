require 'rails_helper'

RSpec.describe 'admin_dashboard', type: :feature do
  describe 'As an admin, when I visit the admin dashboard' do
    before(:each) do
      visit admin_index_path
    end

    it 'I see a header indicating that I am on the admin dashboard' do
      expect(page).to have_content('Admin Dashboard')
    end
  end
end