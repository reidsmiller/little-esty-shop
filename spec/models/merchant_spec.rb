require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :bulk_discounts}
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:customers).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
  end

  describe '#instance_methods' do
    before(:each) do
      @merchant_1 = create(:merchant, status: 'enabled')
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant, status: 'enabled')
      @merchant_4 = create(:merchant)
    end

    describe '.enabled?' do
      it 'can find all enabled merchants' do
        expect(Merchant.enabled?).to eq([@merchant_1, @merchant_3])
      end
    end

    describe '.disabled?' do
      it 'can find all disabled merchants' do
        expect(Merchant.disabled?).to eq([@merchant_2, @merchant_4])
      end
    end
  end

  describe '.top_5_merchants_by_total_revenue' do
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
    end

    it 'calculates revenue for an invoice by sum of revenue of all invoice items' do
      invoice_1 = create(:invoice, customer_id: @customers.sample.id)
      invoice_2 = create(:invoice, customer_id: @customers.sample.id)
      invoice_3 = create(:invoice, customer_id: @customers.sample.id)
      invoice_4 = create(:invoice, customer_id: @customers.sample.id)
      invoice_5 = create(:invoice, customer_id: @customers.sample.id)
      invoice_6 = create(:invoice, customer_id: @customers.sample.id)
      invoice_7 = create(:invoice, customer_id: @customers.sample.id)

      create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 2, item_id: @merchant_item_2.id, invoice_id: invoice_2.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 3, item_id: @merchant_item_3.id, invoice_id: invoice_3.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 4, item_id: @merchant_item_4.id, invoice_id: invoice_4.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 5, item_id: @merchant_item_5.id, invoice_id: invoice_5.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 6, item_id: @merchant_item_6.id, invoice_id: invoice_6.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 7, item_id: @merchant_item_7.id, invoice_id: invoice_7.id, quantity: 1, unit_price:10000)

      create(:transaction, invoice_id: invoice_1.id, result: 'success')
      create(:transaction, invoice_id: invoice_2.id, result: 'success')
      create(:transaction, invoice_id: invoice_3.id, result: 'success')
      create(:transaction, invoice_id: invoice_4.id, result: 'success')
      create(:transaction, invoice_id: invoice_5.id, result: 'success')
      create(:transaction, invoice_id: invoice_6.id, result: 'success')
      create(:transaction, invoice_id: invoice_7.id, result: 'success')

      merchants = Merchant.top_5_merchants_by_total_revenue

      expect(merchants.first.total_revenue).to eq(70000)
      expect(merchants.second.total_revenue).to eq(60000)
      expect(merchants.third.total_revenue).to eq(50000)
      expect(merchants).to eq([@merchant_7, @merchant_6, @merchant_5, @merchant_4, @merchant_3])

    end

    it 'calculates each invoice item revenue by unit_price and quantity' do
      invoice_1 = create(:invoice, customer_id: @customers.sample.id)
      invoice_2 = create(:invoice, customer_id: @customers.sample.id)
      invoice_3 = create(:invoice, customer_id: @customers.sample.id)
      invoice_4 = create(:invoice, customer_id: @customers.sample.id)
      invoice_5 = create(:invoice, customer_id: @customers.sample.id)
      invoice_6 = create(:invoice, customer_id: @customers.sample.id)
      invoice_7 = create(:invoice, customer_id: @customers.sample.id)

      create(:invoice_item, item_id: @merchant_item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_2.id, invoice_id: invoice_2.id, quantity: 2, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_3.id, invoice_id: invoice_3.id, quantity: 3, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_4.id, invoice_id: invoice_4.id, quantity: 4, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_5.id, invoice_id: invoice_5.id, quantity: 5, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_6.id, invoice_id: invoice_6.id, quantity: 6, unit_price:10000)
      create(:invoice_item, item_id: @merchant_item_7.id, invoice_id: invoice_7.id, quantity: 7, unit_price:10000)

      create(:transaction, invoice_id: invoice_1.id, result: 'success')
      create(:transaction, invoice_id: invoice_2.id, result: 'success')
      create(:transaction, invoice_id: invoice_3.id, result: 'success')
      create(:transaction, invoice_id: invoice_4.id, result: 'success')
      create(:transaction, invoice_id: invoice_5.id, result: 'success')
      create(:transaction, invoice_id: invoice_6.id, result: 'success')
      create(:transaction, invoice_id: invoice_7.id, result: 'success')

      merchants = Merchant.top_5_merchants_by_total_revenue

      expect(merchants.first.total_revenue).to eq(70000)
      expect(merchants.second.total_revenue).to eq(60000)
      expect(merchants.third.total_revenue).to eq(50000)
      expect(merchants).to eq([@merchant_7, @merchant_6, @merchant_5, @merchant_4, @merchant_3])
    end

    it 'only invoices with at least one successful transaction should count towards revenue' do
      invoice_1 = create(:invoice, customer_id: @customers.sample.id)
      invoice_2 = create(:invoice, customer_id: @customers.sample.id)
      invoice_3 = create(:invoice, customer_id: @customers.sample.id)
      invoice_4 = create(:invoice, customer_id: @customers.sample.id)
      invoice_5 = create(:invoice, customer_id: @customers.sample.id)
      invoice_6 = create(:invoice, customer_id: @customers.sample.id)
      invoice_7 = create(:invoice, customer_id: @customers.sample.id)
      invoice_8 = create(:invoice, customer_id: @customers.sample.id)

      create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 2, item_id: @merchant_item_2.id, invoice_id: invoice_2.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 3, item_id: @merchant_item_3.id, invoice_id: invoice_3.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 4, item_id: @merchant_item_4.id, invoice_id: invoice_4.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 5, item_id: @merchant_item_5.id, invoice_id: invoice_5.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 6, item_id: @merchant_item_6.id, invoice_id: invoice_6.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 7, item_id: @merchant_item_7.id, invoice_id: invoice_7.id, quantity: 1, unit_price:10000)
      create_list(:invoice_item, 2, item_id: @merchant_item_7.id, invoice_id: invoice_8.id, quantity: 1, unit_price:10000)

      create(:transaction, invoice_id: invoice_1.id, result: 'success')
      create(:transaction, invoice_id: invoice_2.id, result: 'failed')
      create(:transaction, invoice_id: invoice_3.id, result: 'success')
      create(:transaction, invoice_id: invoice_4.id, result: 'success')
      create(:transaction, invoice_id: invoice_5.id, result: 'success')
      create(:transaction, invoice_id: invoice_6.id, result: 'failed')
      create(:transaction, invoice_id: invoice_6.id, result: 'success')
      create(:transaction, invoice_id: invoice_7.id, result: 'failed')
      create(:transaction, invoice_id: invoice_8.id, result: 'success')

      merchants = Merchant.top_5_merchants_by_total_revenue

      expect(merchants).to eq([@merchant_6, @merchant_5, @merchant_4, @merchant_3, @merchant_7])
      expect(merchants.first.total_revenue).to eq(60_000)
      expect(merchants.second.total_revenue).to eq(50_000)
      expect(merchants.third.total_revenue).to eq(40_000)
      expect(merchants.last.total_revenue).to eq(20_000)
    end
  end

  describe 'instance methods' do
    describe '#top_selling_date' do
      before(:each) do
        @customers = create_list(:customer, 20)

        @merchant_1 = create(:merchant)
        @merchant_2 = create(:merchant)

        @invoice_1 = create(:invoice, customer_id: @customers.sample.id, created_at: 2.days.ago)
        @invoice_2 = create(:invoice, customer_id: @customers.sample.id, created_at: 2.days.ago)
        @invoice_3 = create(:invoice, customer_id: @customers.sample.id, created_at: 3.days.ago)
        @invoice_4 = create(:invoice, customer_id: @customers.sample.id, created_at: 4.days.ago)
        @invoice_5 = create(:invoice, customer_id: @customers.sample.id, created_at: 5.days.ago)
        @invoice_6 = create(:invoice, customer_id: @customers.sample.id, created_at: 4.days.ago)
        @invoice_7 = create(:invoice, customer_id: @customers.sample.id, created_at: 3.days.ago)

        @merchant_item_1 = create(:item, merchant_id: @merchant_1.id, unit_price: 10_000)
        @merchant_item_2 = create(:item, merchant_id: @merchant_2.id, unit_price: 10_000)

        create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price:10_000)
        create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: @invoice_2.id, quantity: 6, unit_price:10_000)
        create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: @invoice_3.id, quantity: 3, unit_price:10_000)
        create_list(:invoice_item, 1, item_id: @merchant_item_1.id, invoice_id: @invoice_4.id, quantity: 1, unit_price:10_000)
        create_list(:invoice_item, 1, item_id: @merchant_item_2.id, invoice_id: @invoice_5.id, quantity: 3, unit_price:10_000)
        create_list(:invoice_item, 1, item_id: @merchant_item_2.id, invoice_id: @invoice_6.id, quantity: 10, unit_price:10_000)
        create_list(:invoice_item, 1, item_id: @merchant_item_2.id, invoice_id: @invoice_7.id, quantity: 10, unit_price:10_000)

        create(:transaction, invoice_id: @invoice_1.id, result: 'success')
        create(:transaction, invoice_id: @invoice_2.id, result: 'success')
        create(:transaction, invoice_id: @invoice_3.id, result: 'success')
        create(:transaction, invoice_id: @invoice_4.id, result: 'success')
        create(:transaction, invoice_id: @invoice_5.id, result: 'success')
        create(:transaction, invoice_id: @invoice_6.id, result: 'success')
        create(:transaction, invoice_id: @invoice_7.id, result: 'success')
      end

      it 'can find top selling date for each merchant, if two days are equal retrun most recent day' do
        expect(@merchant_1.top_selling_date).to eq(@invoice_2.format_time_stamp)
        expect(@merchant_2.top_selling_date).to eq(@invoice_7.format_time_stamp)
      end
    end
  end

  describe 'instance_methods' do
    
    let!(:merchant) { create(:merchant) }
    let!(:merchant_1) { create(:merchant) }
    
    let!(:item_1) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_2) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_3) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_4) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_5) { create(:item, merchant_id: merchant.id, status: 1) }
    let!(:item_6) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_7) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_8) { create(:item, merchant_id: merchant.id, status: 0) }
    let!(:item_9) { create(:item, merchant_id: merchant_1.id) }
  
    let!(:customer_1) { create(:customer, first_name: 'Branden', last_name: 'Smith') }
    let!(:customer_2) { create(:customer, first_name: 'Reilly', last_name: 'Robertson') }
    let!(:customer_3) { create(:customer, first_name: 'Grace', last_name: 'Chavez') }
    let!(:customer_4) { create(:customer, first_name: 'Logan', last_name: 'Nguyen') }
    let!(:customer_5) { create(:customer, first_name: 'Brandon', last_name: 'Popular') }
    let!(:customer_6) { create(:customer, first_name: 'Caroline', last_name: 'Rasmussen') }
  
    static_time_1 = Time.zone.parse('2023-04-13 00:50:37')
    static_time_2 = Time.zone.parse('2023-04-12 00:50:37')
  
    let!(:invoice_1) { create(:invoice, customer_id: customer_1.id) }
    let!(:invoice_2) { create(:invoice, customer_id: customer_2.id) }
    let!(:invoice_3) { create(:invoice, customer_id: customer_3.id) }
    let!(:invoice_4) { create(:invoice, customer_id: customer_4.id, created_at: static_time_1) }
    let!(:invoice_5) { create(:invoice, customer_id: customer_5.id, created_at: static_time_2) }
    let!(:invoice_6) { create(:invoice, customer_id: customer_6.id) }
    let!(:invoice_7) { create(:invoice, customer_id: customer_6.id) }
  
    let!(:invoice_item_1) { create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, unit_price: 1000, quantity: 5) }
    let!(:invoice_item_2) { create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 2, unit_price: 500, quantity: 25) }
    let!(:invoice_item_3) { create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2, unit_price: 10000, quantity: 4) }
    let!(:invoice_item_4) { create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 0, unit_price: 1000, quantity: 10) }
    let!(:invoice_item_5) { create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 0, unit_price: 500, quantity: 60) }
    let!(:invoice_item_6) { create(:invoice_item, item_id: item_6.id, invoice_id: invoice_6.id, status: 1, unit_price: 5000, quantity: 10) }
    let!(:invoice_item_7) { create(:invoice_item, item_id: item_9.id, invoice_id: invoice_7.id, status: 1, unit_price: 10000, quantity: 20) }
  
    let!(:inv_1_transaction_s) { create_list(:transaction, 10, result: 1, invoice_id: invoice_1.id) }
    let!(:inv_1_transaction_f) { create_list(:transaction, 5, result: 0, invoice_id: invoice_1.id) }
    let!(:inv_2_transaction_s) { create_list(:transaction, 5, result: 1, invoice_id: invoice_2.id) }
    let!(:inv_3_transaction_s) { create_list(:transaction, 7, result: 1, invoice_id: invoice_3.id) }
    let!(:inv_4_transaction_s) { create_list(:transaction, 3, result: 1, invoice_id: invoice_4.id) }
    let!(:inv_4_transaction_f) { create_list(:transaction, 20, result: 0, invoice_id: invoice_4.id) }
    let!(:inv_5_transaction_s) { create_list(:transaction, 11, result: 1, invoice_id: invoice_5.id) }
    let!(:inv_6_transaction_s) { create_list(:transaction, 8, result: 1, invoice_id: invoice_6.id) }
    let!(:inv_7_transaction_f) { create_list(:transaction, 60, result: 0, invoice_id: invoice_7.id)}
    
    describe '#top_five_customers' do
      it '#customers retrieves five customers with the highest number of successful transactions from highest to lowest' do
        expect(merchant.top_five_customers).to eq([customer_5, customer_1, customer_6, customer_3, customer_2])
      end
    end
  
    describe '#unshipped_items' do
      it 'retrieves items from this merchant that have an order and that order status is not shipped from oldest to newest' do
        expect(merchant.unshipped_items).to eq([item_5, item_4, item_6])
      end
    end

    describe '#enabled_items' do
      it 'retreives only items that have enabled status from this merchant' do
        expect(merchant.enabled_items.sort).to eq([item_1, item_6, item_7, item_8].sort)
        expect(merchant.enabled_items).to_not eq([item_2, item_3, item_4, item_5])
      end
    end

    describe '#disabled_items' do
      it 'retreives only items that have disabled status from this merchant' do
        expect(merchant.disabled_items.sort).to eq([item_2, item_3, item_4, item_5].sort)
        expect(merchant.disabled_items).to_not eq([item_1, item_6, item_7, item_8])
      end
    end

    describe 'top_5_items' do
      it 'returns the top 5 items ranked by total revenue generated, but only if they have at least one succesful transaction for this merchant' do
        expect(merchant.top_5_items).to eq([item_6, item_5, item_3, item_2, item_1])
      end
    end
  end 
end