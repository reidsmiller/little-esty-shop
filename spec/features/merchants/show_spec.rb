# 1. Merchant Dashboard

# As a merchant,
# When I visit my merchant dashboard (/merchants/merchant_id/dashboard)
# Then I see the name of my merchant
require 'rails_helper'

RSpec.describe 'Merchant Dashboard/Show Page' do
  let!(:merchant) {create(:merchant)}
  describe 'displays Merchants and their most recent attributes' do
    it 'should display the name of the merchant' do
      
      visit "/merchants/#{merchant.id}/dashboard"

      expect(page).to have_content(merchant.name)
    end
  end
end