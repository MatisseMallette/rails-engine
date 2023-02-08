require 'rails_helper'

RSpec.describe 'Api::V1::Items::FindController', type: :request do
  describe 'get api/v1/items/find?name=' do
    it 'returns a specific item when given a name' do
      m1 = create(:merchant, name: 'Jeff')
      create_list(:item, 5, name: 'Tings', merchant_id: m1.id)
      item = create(:item, name: 'Thing', description: 'Thing Description', unit_price: 100, merchant_id: m1.id)

      get "/api/v1/items/find?name=th"

      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item_data).to have_key(:id)

      expect(item_data[:id]).to eq(Item.find(item.id).id.to_s)

      attributes = item_data[:attributes]

      expect(attributes[:name]).to eq(item.name)
    end

    
  end

  describe 'get api/v1/items/find?max_price' do 
    it 'returns a specific item when given a maximum price' do
      m1 = create(:merchant, name: 'Jeff')
      create_list(:item, 5, name: 'Tings', unit_price: 95, merchant_id: m1.id)
      item = create(:item, name: 'Thing', description: 'Thing Description', unit_price: 100, merchant_id: m1.id)

      get "/api/v1/items/find?max_price=150"
      # binding.pry
      expect(response).to be_successful

      item_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item_data).to have_key(:id)

      expect(item_data[:id]).to eq(Item.find(item.id).id.to_s)

      attributes = item_data[:attributes]

      expect(attributes[:name]).to eq(item.name)
    end
  end
end
