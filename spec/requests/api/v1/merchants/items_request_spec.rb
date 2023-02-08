require 'rails_helper'

RSpec.describe 'Api::V1::MerchantsController', type: :request do
  describe 'get api/v1/merchants/:id/items' do
    it 'returns a specific merchants items' do
      m1 = create(:merchant)
      m2 = create(:merchant)
      create_list(:item, 3, merchant_id: m1.id)
      create(:item, merchant_id: m2.id)

      get "/api/v1/merchants/#{m1.id}/items"

      expect(response).to be_successful

      m1_items = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(m1_items.count).to eq(3)

      get "/api/v1/merchants/#{m2.id}/items"

      expect(response).to be_successful

      m2_items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(m2_items.count).to eq(1)

      m1_items.each do |i|
        expect(i).to have_key(:id)
        expect(i[:attributes]).to have_key(:name)
        expect(i[:attributes]).to have_key(:description)
        expect(i[:attributes]).to have_key(:unit_price)
        expect(i[:attributes]).to have_key(:merchant_id)
      end
    end
  end
end
