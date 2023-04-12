require 'rails_helper'

RSpec.describe 'admin_dashboard', type: :feature do
  describe 'As an admin, when I visit the admin dashboard' do
    before(:each) do
      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
      @customer_3 = create(:customer)
      @customer_4 = create(:customer)
      @customer_5 = create(:customer)
      @customer_6 = create(:customer)
      @customer_7 = create(:customer)
      
      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
      @invoice_2 = create(:invoice, customer_id: @customer_2.id)
      @invoice_3 = create(:invoice, customer_id: @customer_3.id)
      @invoice_4 = create(:invoice, customer_id: @customer_4.id)
      @invoice_5 = create(:invoice, customer_id: @customer_5.id)
      @invoice_6 = create(:invoice, customer_id: @customer_6.id)
      @invoice_7 = create(:invoice, customer_id: @customer_7.id)
      
      create_list(:transaction, 3, result: 'success', invoice_id: @invoice_1.id)
      create_list(:transaction, 4, result: 'success', invoice_id: @invoice_2.id)
      create_list(:transaction, 5, result: 'success', invoice_id: @invoice_3.id)
      create_list(:transaction, 6, result: 'success', invoice_id: @invoice_4.id)
      create_list(:transaction, 7, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_5.id)
      create_list(:transaction, 2, result: 'success', invoice_id: @invoice_7.id)
      create_list(:transaction, 5, result: 'failed', invoice_id: @invoice_7.id)
      
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

    it 'I see the names of the top 5 customers who have conducted the largest number of successful transactions' do
      within("div#successful_transactions") do
        save_and_open_page
        expect(page).to have_content("Top 5 Customers with largest number of successful transactions:")
        expect(page).to have_content(@customer_5.last_name)
        expect(page).to have_content(@customer_4.last_name)
        expect(page).to have_content(@customer_3.last_name)
        expect(page).to have_content(@customer_2.last_name)
        expect(page).to have_content(@customer_1.last_name)
        expect(@customer_5.first_name).to appear_before(@customer_4.first_name)
        expect(@customer_4.first_name).to appear_before(@customer_3.first_name)
        expect(@customer_3.first_name).to appear_before(@customer_2.first_name)
        expect(@customer_2.first_name).to appear_before(@customer_1.first_name)
        expect(page).to_not have_content(@customer_6.first_name)
        expect(page).to_not have_content(@customer_6.last_name)
        expect(page).to_not have_content(@customer_7.first_name)
        expect(page).to_not have_content(@customer_7.last_name)
      end
    end

    it 'next to each customer name I see the number of successful transactions they have conducted' do
      within("div#successful_transactions") do
        expect(page).to have_content("#{@customer_5.first_name} #{@customer_5.last_name}: 7")
        expect(page).to have_content("#{@customer_4.first_name} #{@customer_4.last_name}: 6")
        expect(page).to have_content("#{@customer_3.first_name} #{@customer_3.last_name}: 5")
        expect(page).to have_content("#{@customer_2.first_name} #{@customer_2.last_name}: 4")
        expect(page).to have_content("#{@customer_1.first_name} #{@customer_1.last_name}: 3")
      end
    end
  end
end