require 'rails_helper'

RSpec.describe 'Api::V1::Items::FindAllController', type: :request do
  describe 'get api/v1/items/find_all' do
    it 'returns a specific merchants when given a name' do
      m1 = create(:merchant, name: 'Merchantmin')
      create_list(:item, 3, name: ['Bob', '123', 'Ringo'], description: "Foo", unit_price: 100, merchant_id: m1.id)

      i1 = create(:item, name: 'Jeff', merchant_id: m1.id, description: "Foo", unit_price: 100)
      i2 = create(:item, name: 'Jerome', merchant_id: m1.id, description: "Foo", unit_price: 100)
      i3 = create(:item, name: 'jeremy', merchant_id: m1.id, description: "Foo", unit_price: 100)
      i4 = create(:item, name: 'jenny', merchant_id: m1.id, description: "Foo", unit_price: 100)

      
      
      get "/api/v1/items/find_all?name=Je"

      expect(response).to be_successful

      items_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items_data.count).to eq(4)

      [i1, i2, i3, i4].each.with_index(0) do |item, index|
        i_d = items_data[index]
        expect(i_d).to have_key(:id)
        expect(i_d[:id]).to eq(item.id.to_s)
        expect(i_d[:attributes][:name]).to eq(item.name)
      end
    end

    it 'returns a specific merchants when given a minimum price' do
      m1 = create(:merchant, name: 'Merchantmin')
      i1 = create(:item, name: "Thing", description: 'Foo', unit_price: 90, merchant_id: m1.id)
      i2 = create(:item, name: "Thang", description: 'Foo', unit_price: 95, merchant_id: m1.id)
      i3 = create(:item, name: "Florb", description: 'Foo', unit_price: 100, merchant_id: m1.id)
      i4 = create(:item, name: "Flib", description: 'Foo', unit_price: 150, merchant_id: m1.id)

      get "/api/v1/items/find_all?min_price=95"
      
      expect(response).to be_successful

      items_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items_data.count).to eq(3)
    end

    it 'returns a specific merchants when given a maximum price' do
      m1 = create(:merchant, name: 'Merchantmin')
      i1 = create(:item, name: "Thing", description: 'Foo', unit_price: 90, merchant_id: m1.id)
      i2 = create(:item, name: "Thang", description: 'Foo', unit_price: 95, merchant_id: m1.id)
      i3 = create(:item, name: "Florb", description: 'Foo', unit_price: 100, merchant_id: m1.id)
      i4 = create(:item, name: "Flib", description: 'Foo', unit_price: 150, merchant_id: m1.id)

      get "/api/v1/items/find_all?max_price=95"
      
      expect(response).to be_successful

      items_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items_data.count).to eq(2)
    end
  end
end