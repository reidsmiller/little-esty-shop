require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
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
end