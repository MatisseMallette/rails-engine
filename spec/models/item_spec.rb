# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item do
  describe 'Relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :description }
  end

  describe 'Class Methods' do
    describe '#find_all_by_name' do
      it 'returns all items based on name' do
        create(:merchant)
        create_list(:item, 5, name: 'Thing', merchant_id: Merchant.last.id)
        create(:item, name: 'Thang', merchant_id: Merchant.last.id)

        Item.find_all_by_name('Thing').each do |i|
          expect(i.name).to eq('Thing')
        end
      end

      it 'returns all items based on partial name regardless of case' do
        create(:merchant)
        create_list(:item, 5, name: 'Thing', merchant_id: Merchant.last.id)
        create(:item, name: 'Thang', merchant_id: Merchant.last.id)

        Item.find_all_by_name('thi').each do |i|
          expect(i.name).to eq('Thing')
        end
      end
    end

    describe '#find_all_by_price' do
      it 'returns all items based on a given minimum price' do
        create(:merchant)
        create_list(:item, 5, unit_price: Faker::Number.within(range: 0.0..99.9), merchant_id: Merchant.last.id)
        items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.0..150.0),
                                      merchant_id: Merchant.last.id)

        expect(Item.find_all_by_price(100, nil)).to eq(items)
      end

      it 'returns all items based on a given maximum price' do
        create(:merchant)
        items = create_list(:item, 5, unit_price: Faker::Number.within(range: 0.0..99.9), merchant_id: Merchant.last.id)
        create_list(:item, 5, unit_price: Faker::Number.within(range: 100.0..150.0), merchant_id: Merchant.last.id)

        expect(Item.find_all_by_price(nil, 100)).to eq(items)
      end

      it 'returns all items based on a given minimum and maximum price' do
        create(:merchant)
        create_list(:item, 5, unit_price: Faker::Number.within(range: 0.0..99.9), merchant_id: Merchant.last.id)
        items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.0..150.0),
                                      merchant_id: Merchant.last.id)
        create_list(:item, 5, unit_price: Faker::Number.within(range: 151.0..1000.0), merchant_id: Merchant.last.id)

        expect(Item.find_all_by_price(100, 150)).to eq(items)
      end

      it 'returns an empty array if no items are found' do
        create(:merchant)
        create_list(:item, 5, unit_price: Faker::Number.within(range: 0.0..99.9), merchant_id: Merchant.last.id)

        expect(Item.find_all_by_price(100, 150)).to eq([])
      end
    end

    describe '#find_by_name' do
      it 'returns an item based on name' do
        create(:merchant)
        create_list(:item, 10, merchant_id: Merchant.last.id)
        item = Item.first

        expect(Item.find_by_name(item.name)).to eq(item)
      end

      it 'returns an item based on partial name regardless of case' do
        create(:merchant)
        create(:item, name: 'Thing', merchant_id: Merchant.last.id)
        create(:item, name: 'Thang', merchant_id: Merchant.last.id)

        expect(Item.find_by_name('thi')).to eq(Item.first)
      end
    end

    # describe '#find_by_price' do
    #   it 'returns an item based on a given minimum price' do
    #     create(:merchant)
    #     cheapest_item = create(:item, unit_price: 99.0, merchant_id: Merchant.last.id)
    #     create_list(:item, 5, unit_price: Faker::Number.within(range: 100.0..150.0), merchant_id: Merchant.last.id)

    #     expect(Item.find_by_price(99, nil)).to eq(cheapest_item)
    #   end

    #   it 'returns an item based on a given maximum price' do
    #     create(:merchant)
    #     create_list(:item, 5, unit_price: Faker::Number.within(range: 0.00..99.99), merchant_id: Merchant.last.id)
    #     costliest_item = create(:item, name: 'Thing', unit_price: 100, merchant_id: Merchant.last.id)
    #     expect(Item.find_by_price(nil, 100)).to eq(costliest_item)
    #   end

    #   it 'returns an item based on a given minimum and maximum price' do
    #     create(:merchant)
    #     create_list(:item, 5, unit_price: Faker::Number.within(range: 0.0..99.9), merchant_id: Merchant.last.id)
    #     items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.0..150.0), merchant_id: Merchant.last.id)
    #     create_list(:item, 5, unit_price: Faker::Number.within(range: 151.0..1000.0), merchant_id: Merchant.last.id)

    #     expect(Item.find_by_price(100, 150)).to eq(items)
    #   end

    #   it 'returns nil if no items are found' do
    #     create(:merchant)
    #     create_list(:item, 5, unit_price: Faker::Number.within(range: 0.0..99.9), merchant_id: Merchant.last.id)

    #     expect(Item.find_by_price(100, 150)).to eq({})
    #   end
    # end
  end
end
