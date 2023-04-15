require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:items)}
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
end