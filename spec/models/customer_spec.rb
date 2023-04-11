require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:items).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe '#instance methods' do
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

      create(:transaction, result: 'success', invoice_id: @invoice_1.id)
      create(:transaction, result: 'success', invoice_id: @invoice_1.id)
      create(:transaction, result: 'success', invoice_id: @invoice_1.id)
      create(:transaction, result: 'success', invoice_id: @invoice_2.id)
      create(:transaction, result: 'success', invoice_id: @invoice_2.id)
      create(:transaction, result: 'success', invoice_id: @invoice_2.id)
      create(:transaction, result: 'success', invoice_id: @invoice_2.id)
      create(:transaction, result: 'success', invoice_id: @invoice_3.id)
      create(:transaction, result: 'success', invoice_id: @invoice_3.id)
      create(:transaction, result: 'success', invoice_id: @invoice_3.id)
      create(:transaction, result: 'success', invoice_id: @invoice_3.id)
      create(:transaction, result: 'success', invoice_id: @invoice_3.id)
      create(:transaction, result: 'success', invoice_id: @invoice_4.id)
      create(:transaction, result: 'success', invoice_id: @invoice_4.id)
      create(:transaction, result: 'success', invoice_id: @invoice_4.id)
      create(:transaction, result: 'success', invoice_id: @invoice_4.id)
      create(:transaction, result: 'success', invoice_id: @invoice_4.id)
      create(:transaction, result: 'success', invoice_id: @invoice_4.id)
      create(:transaction, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'success', invoice_id: @invoice_5.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_5.id)
      create(:transaction, result: 'success', invoice_id: @invoice_7.id)
      create(:transaction, result: 'success', invoice_id: @invoice_7.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_7.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_7.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_7.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_7.id)
      create(:transaction, result: 'failed', invoice_id: @invoice_7.id)
    end

    describe '.top_5_successful_trans' do
      it 'can find the top 5 customers with highest number successful transactions' do
        expect(Customer.top_5_successful_trans).to eq([@customer_5, @customer_4, @customer_3, @customer_2, @customer_1])
      end
    end

    describe '.success_transaction_count' do
      it 'can count a customers number of transactions' do
        expect(@customer_5.success_transaction_count).to eq(7)
        expect(@customer_4.success_transaction_count).to eq(6)
        expect(@customer_7.success_transaction_count).to eq(2)
      end
    end
  end
end