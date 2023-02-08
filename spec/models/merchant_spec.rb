require 'rails_helper'

RSpec.describe Merchant do 
  describe 'Relationships' do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe 'Class Methods' do
    describe '#find_by_name' do 
      it 'returns a merchant based on name' do
        create_list(:merchant, 3)
        merchant = Merchant.first
  
        expect(Merchant.find_by_name(merchant.name)).to eq(merchant)
      end
  
      it 'returns a merchant based on partial name regardless of case' do 
        create(:merchant, name: 'Jeff')
        create(:merchant, name: 'Bob')
  
        expect(Merchant.find_by_name('je')).to eq(Merchant.first)
      end
    end

    describe '#find_all_by_name' do 
      it 'returns all merchants based on name' do 
        create_list(:merchant, 9, name: 'Todd')
        create(:merchant, name: 'Jeff')

        Merchant.find_all_by_name('je').each do |i|
          expect(i.name).to eq('Jeff')
        end
      end
    end
  end
end
