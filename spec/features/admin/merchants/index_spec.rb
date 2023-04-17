require 'rails_helper'

RSpec.describe 'admin_merchants_index', type: :feature do
  describe 'As an admin, when I visit the admin merchants index' do
    before(:each) do
      @merchant_1 = create(:merchant, status: 'enabled')
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant, status: 'enabled')
      @merchant_4 = create(:merchant)
      
      visit admin_merchants_path
    end

    it 'I see the name of each merchant in the system' do
      expect(page).to have_content("Admin Merchant Index Page")
      expect(page).to have_link("#{@merchant_1.name}")
      expect(page).to have_link("#{@merchant_2.name}")
      expect(page).to have_link("#{@merchant_3.name}")
      expect(page).to have_link("#{@merchant_4.name}")
    end

    it 'when I click merchant name link I am taken to that merchants admin show page and see the name of that merchant' do
      visit admin_merchants_path

      click_link "#{@merchant_1.name}"
      expect(current_path).to eq(admin_merchant_path(@merchant_1))
      expect(page).to have_content("#{@merchant_1.name}")

      visit admin_merchants_path
      click_link "#{@merchant_2.name}"
      expect(current_path).to eq(admin_merchant_path(@merchant_2))
      expect(page).to have_content("#{@merchant_2.name}")
    end

    it 'I see a button next to each merchant to either disable or enable that merchant' do
      visit admin_merchants_path

      within("li#admin_#{@merchant_1.id}") do
        expect(page).to have_button('Disable')
        expect(page).to_not have_button('Enable')
      end

      within("li#admin_#{@merchant_2.id}") do
        expect(page).to have_button('Enable')
        expect(page).to_not have_button('Disable')
      end

      within("li#admin_#{@merchant_3.id}") do
        expect(page).to_not have_button('Enable')
        expect(page).to have_button('Disable')
      end

      within("li#admin_#{@merchant_4.id}") do
        expect(page).to have_button('Enable')
        expect(page).to_not have_button('Disable')
      end
    end

    it 'when I click enable or disable it changes the merchants status and I am redirected back to merchant index' do
      visit admin_merchants_path

      within("li#admin_#{@merchant_1.id}") do
        expect(Merchant.find(@merchant_1.id).status).to eq('enabled')
        click_button 'Disable'
        expect(current_path).to eq(admin_merchants_path)
        expect(Merchant.find(@merchant_1.id).status).to eq('disabled')
      end

      within("li#admin_#{@merchant_2.id}") do
        expect(Merchant.find(@merchant_2.id).status).to eq('disabled')
        click_button 'Enable'
        expect(current_path).to eq(admin_merchants_path)
        expect(Merchant.find(@merchant_2.id).status).to eq('enabled')
      end
    end

    it 'I see a section for enabled merchants and disabled merchants and see each merchant in the appropriate section' do
      visit admin_merchants_path

      expect(page).to have_content("Enabled Merchants")
      expect(page).to have_content("Disabled Merchants")

      within("div#enabled_merchants") do
        expect(page).to have_link("#{@merchant_1.name}")
        expect(page).to_not have_link("#{@merchant_2.name}")
        expect(page).to have_link("#{@merchant_3.name}")
        expect(page).to_not have_link("#{@merchant_4.name}")
      end

      within("div#disabled_merchants") do
        expect(page).to_not have_link("#{@merchant_1.name}")
        expect(page).to have_link("#{@merchant_2.name}")
        expect(page).to_not have_link("#{@merchant_3.name}")
        expect(page).to have_link("#{@merchant_4.name}")
      end

      within("li#admin_#{@merchant_1.id}") do
        click_button 'Disable'
      end

      within("div#enabled_merchants") do
        expect(page).to_not have_link("#{@merchant_1.name}")
        expect(page).to_not have_link("#{@merchant_2.name}")
        expect(page).to have_link("#{@merchant_3.name}")
        expect(page).to_not have_link("#{@merchant_4.name}")
      end

      within("div#disabled_merchants") do
        expect(page).to have_link("#{@merchant_1.name}")
        expect(page).to have_link("#{@merchant_2.name}")
        expect(page).to_not have_link("#{@merchant_3.name}")
        expect(page).to have_link("#{@merchant_4.name}")
      end
    end

    it 'I see a link to create a new merchant, and when I click this link I am taken to a new merchant page' do
      visit admin_merchants_path
      expect(page).to have_link('Create New Merchant')
      click_link 'Create New Merchant'
      expect(current_path).to eq(new_admin_merchant_path)
    end
  end
  
  describe 'I see the names of the top 5 merchants by total revenue generated' do
    before(:each) do
      @customers = create_list(:customer, 20)

      @merchant_1 = create(:merchant, status: 'enabled')
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant, status: 'enabled')
      @merchant_4 = create(:merchant)
      @merchant_5 = create(:merchant)
      @merchant_6 = create(:merchant)
      @merchant_7 = create(:merchant)

      @merchant_item_1 = create(:item, merchant_id: @merchant_1.id, unit_price: 10000)
      @merchant_item_2 = create(:item, merchant_id: @merchant_2.id, unit_price: 10000)
      @merchant_item_3 = create(:item, merchant_id: @merchant_3.id, unit_price: 10000)
      @merchant_item_4 = create(:item, merchant_id: @merchant_4.id, unit_price: 10000)
      @merchant_item_5 = create(:item, merchant_id: @merchant_5.id, unit_price: 10000)
      @merchant_item_6 = create(:item, merchant_id: @merchant_6.id, unit_price: 10000)
      @merchant_item_7 = create(:item, merchant_id: @merchant_7.id, unit_price: 10000)

      @invoice_1 = create(:invoice, customer_id: @customers.sample.id)
      @invoice_2 = create(:invoice, customer_id: @customers.sample.id)
      @invoice_3 = create(:invoice, customer_id: @customers.sample.id)
      @invoice_4 = create(:invoice, customer_id: @customers.sample.id)
      @invoice_5 = create(:invoice, customer_id: @customers.sample.id)
      @invoice_6 = create(:invoice, customer_id: @customers.sample.id)
      @invoice_7 = create(:invoice, customer_id: @customers.sample.id)
    end

    it 'and should calculate revenue for an invoice by sum of revenue of all invoice items and each merchant name links to its show page' do

      create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 2, item_id: @merchant_item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 3, item_id: @merchant_item_3.id, invoice_id: @invoice_3.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 4, item_id: @merchant_item_4.id, invoice_id: @invoice_4.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 5, item_id: @merchant_item_5.id, invoice_id: @invoice_5.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 6, item_id: @merchant_item_6.id, invoice_id: @invoice_6.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 7, item_id: @merchant_item_7.id, invoice_id: @invoice_7.id, quantity: 1, unit_price:10000)

      create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      create(:transaction, invoice_id: @invoice_5.id, result: 'success')
      create(:transaction, invoice_id: @invoice_6.id, result: 'success')
      create(:transaction, invoice_id: @invoice_7.id, result: 'success')

      visit admin_merchants_path
      
      within("div#top_5_merchants_by_revenue") do
        expect(page).to have_content("Top 5 Merchants by Revenue")

        expect(page).to have_link("#{@merchant_7.name}", href: admin_merchant_path(@merchant_7))
        expect(page).to have_link("#{@merchant_6.name}", href: admin_merchant_path(@merchant_6))
        expect(page).to have_link("#{@merchant_5.name}", href: admin_merchant_path(@merchant_5))
        expect(page).to have_link("#{@merchant_4.name}", href: admin_merchant_path(@merchant_4))
        expect(page).to have_link("#{@merchant_3.name}", href: admin_merchant_path(@merchant_3))
        expect(page).to_not have_link("#{@merchant_2.name}")
        expect(page).to_not have_link("#{@merchant_1.name}")

        expect(@merchant_7.name).to appear_before(@merchant_6.name)
        expect(@merchant_6.name).to appear_before(@merchant_5.name)
        expect(@merchant_5.name).to appear_before(@merchant_4.name)
        expect(@merchant_4.name).to appear_before(@merchant_3.name)
      end
    end

    it 'and calculates each invoice item revenue by unit_price and quantity' do
      create(:invoice_item, item_id: @merchant_item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_2.id, invoice_id: @invoice_2.id, quantity: 2, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_3.id, invoice_id: @invoice_3.id, quantity: 3, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_4.id, invoice_id: @invoice_4.id, quantity: 4, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_5.id, invoice_id: @invoice_5.id, quantity: 5, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_6.id, invoice_id: @invoice_6.id, quantity: 6, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_7.id, invoice_id: @invoice_7.id, quantity: 7, unit_price:10000)

      create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      create(:transaction, invoice_id: @invoice_5.id, result: 'success')
      create(:transaction, invoice_id: @invoice_6.id, result: 'success')
      create(:transaction, invoice_id: @invoice_7.id, result: 'success')      

      visit admin_merchants_path
      
      within("div#top_5_merchants_by_revenue") do
        expect(@merchant_7.name).to appear_before(@merchant_6.name)
        expect(@merchant_6.name).to appear_before(@merchant_5.name)
        expect(@merchant_5.name).to appear_before(@merchant_4.name)
        expect(@merchant_4.name).to appear_before(@merchant_3.name)
      end
    end

    it 'and only invoices with at least one successful transaction should count towards revenue' do
      create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 2, item_id: @merchant_item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 3, item_id: @merchant_item_3.id, invoice_id: @invoice_3.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 4, item_id: @merchant_item_4.id, invoice_id: @invoice_4.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 5, item_id: @merchant_item_5.id, invoice_id: @invoice_5.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 6, item_id: @merchant_item_6.id, invoice_id: @invoice_6.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 7, item_id: @merchant_item_7.id, invoice_id: @invoice_7.id, quantity: 1, unit_price:10000)

      create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      create(:transaction, invoice_id: @invoice_5.id, result: 'success')
      create(:transaction, invoice_id: @invoice_6.id, result: 'failed')
      create(:transaction, invoice_id: @invoice_6.id, result: 'success')
      create(:transaction, invoice_id: @invoice_7.id, result: 'failed')

      visit admin_merchants_path

      within("div#top_5_merchants_by_revenue") do
        expect(@merchant_6.name).to appear_before(@merchant_5.name)
        expect(@merchant_5.name).to appear_before(@merchant_4.name)
        expect(@merchant_4.name).to appear_before(@merchant_3.name)
        expect(@merchant_3.name).to appear_before(@merchant_2.name)
        expect(page).to_not have_content(@merchant_7.name)
        expect(page).to_not have_content(@merchant_1.name)
      end
    end
  end

  describe 'top merchants best day' do
    before(:each) do
      @invoice_1 = create(:invoice, customer_id: @customers.sample.id, created_at: 2.days.ago)
      @invoice_2 = create(:invoice, customer_id: @customers.sample.id, created_at: 2.days.ago)
      @invoice_3 = create(:invoice, customer_id: @customers.sample.id, created_at: 3.days.ago)
      @invoice_4 = create(:invoice, customer_id: @customers.sample.id, created_at: 4.days.ago)
      @invoice_5 = create(:invoice, customer_id: @customers.sample.id, created_at: 5.days.ago)
      @invoice_6 = create(:invoice, customer_id: @customers.sample.id, created_at: 4.days.ago)
      @invoice_7 = create(:invoice, customer_id: @customers.sample.id, created_at: 3.days.ago)
   
      @merchant_1 = create(:merchant, status: 'enabled')
      @merchant_2 = create(:merchant)

      @merchant_item_1 = create(:item, merchant_id: @merchant_1.id, unit_price: 10000)
      @merchant_item_2 = create(:item, merchant_id: @merchant_2.id, unit_price: 10000)
      
      create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price:10000)
      create_list(:invoice_item, 2, item_id: @merchant_item_1.id, invoice_id: @invoice_2.id, quantity: 6, unit_price:10000)
      create_list(:invoice_item, 3, item_id: @merchant_item_1.id, invoice_id: @invoice_3.id, quantity: 3, unit_price:10000)
      create_list(:invoice_item, 4, item_id: @merchant_item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 5, item_id: @merchant_item_2.id, invoice_id: @invoice_5.id, quantity: 3, unit_price:10000)
      create_list(:invoice_item, 6, item_id: @merchant_item_2.id, invoice_id: @invoice_6.id, quantity: 10, unit_price:10000)
      create_list(:invoice_item, 7, item_id: @merchant_item_2.id, invoice_id: @invoice_7.id, quantity: 10, unit_price:10000)
    end

    it 'and it shows the date with the most revenue for each merchant' do
      within("li#top_5_#{@merchant_1.id}") do
        expect(page).to have_content("Top selling date for #{@merchant_1.name} was #{@invoice_1.format_time_stamp}")
      end

      within("li#top_5_#{@merchant_2.id}") do
        expect(page).to have_content("Top selling date for #{@merchant_2.name} was #{@invoice_7.format_time_stamp}")
        expect(page).to_not have_content("#{@invoice_6.format_time_stamp}")
      end
    end
  end
end