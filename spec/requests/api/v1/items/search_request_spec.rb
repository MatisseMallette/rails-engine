# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Items::Searches', type: :request do
  describe 'happy path' do
    describe 'items/find_all?name' do
      it 'returns items based on name' do
        create(:merchant, name: 'Jeff')
        items_to_find = create_list(:item, 3, name: 'Thing', merchant_id: Merchant.last.id)
        create_list(:item, 3, name: 'Thang', merchant_id: Merchant.last.id)

        get '/api/v1/items/find_all?name=Thing'

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        items = data[:data]

        items.each.with_index do |item, index|
          expect(item).to have_key(:id)
          expect(item[:id].to_i).to eq(items_to_find[index].id)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to eq(items_to_find[index].name)
        end
      end
    end

    describe 'items/find_all?min_price' do
      it 'returns all items given a minimum price' do
        create(:merchant, name: 'Jeff')
        findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 100.00..1000.00),
                                               merchant_id: Merchant.first.id)
        create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..99.99), merchant_id: Merchant.first.id)

        get '/api/v1/items/find_all?min_price=100'

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        items = data[:data]

        expect(items.count).to eq(5)

        item_ids = findable_items.map(&:id)

        items.each do |item|
          expect(item).to have_key(:id)
          expect(item_ids).to include(item[:id].to_i)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be >= 100
        end
      end
    end

    describe 'items/find_all?max_price' do
      it 'returns all items given a maximum price' do
        create(:merchant, name: 'Jeff')
        create_list(:item, 5, unit_price: Faker::Number.within(range: 101.00..1000.00), merchant_id: Merchant.first.id)
        findable_items = create_list(:item, 5, unit_price: Faker::Number.within(range: 1.00..100.00),
                                               merchant_id: Merchant.first.id)

        get '/api/v1/items/find_all?max_price=100'

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        items = data[:data]

        expect(items.count).to eq(5)

        item_ids = findable_items.map(&:id)

        items.each do |item|
          expect(item).to have_key(:id)
          expect(item_ids).to include(item[:id].to_i)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be <= 100
        end
      end
    end

    describe 'items/find?name' do
      it 'returns an item based on a name' do
        create(:merchant)
        create_list(:item, 10, merchant_id: Merchant.last.id)

        get "/api/v1/items/find?name=#{Item.first.name}"

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        item = data[:data]

        expect(item).to have_key(:id)
        expect(item[:id].to_i).to eq(Item.first.id)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to eq(Item.first.name)
      end
    end
  end

  describe 'sad path' do
    describe 'items/find_all?name' do
      it 'returns nil if name does not match' do
        create(:merchant, name: 'Jeff')
        create_list(:item, 3, name: 'Thing', merchant_id: Merchant.last.id)
        create_list(:item, 3, name: 'Thang', merchant_id: Merchant.last.id)

        get '/api/v1/items/find_all?name=12345'

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:data].empty?).to eq(true)
      end
    end

    describe 'items/find_all?name&min_price' do
      it 'returns an error if given name and min_price' do
        create(:merchant)
        create_list(:item, 3, name: 'Thing', merchant_id: Merchant.last.id)

        get '/api/v1/items/find_all?min_price=100&name=Jordan'

        expect(response).to_not be_successful
      end
    end

    describe 'items/find?name' do
      it 'returns nil if the name does not match' do
        create(:merchant)
        create_list(:item, 3, merchant_id: Merchant.last.id)

        get '/api/v1/items/find?name=12345'

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:data]).to eq({})
      end
    end
  end
end
