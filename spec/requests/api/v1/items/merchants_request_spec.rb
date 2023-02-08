# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Items::MerchantsController', type: :request do
  describe 'get api/v1/items/:id/merchant' do
    it 'returns item merchant' do
      m1 = create(:merchant, name: 'Jeff')
      m2 = create(:merchant, name: 'Bob')

      i1 = create(:item, merchant_id: m1.id)
      i2 = create(:item, merchant_id: m2.id)

      expect(Merchant.all.count).to eq(2)

      get "/api/v1/items/#{i1.id}/merchant"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)[:data]
      merchant_response_name = merchant_response[:attributes][:name]
      expect(m1.name).to eq(merchant_response_name)

      get "/api/v1/items/#{i2.id}/merchant"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)[:data]
      merchant_response_name = merchant_response[:attributes][:name]
      expect(m2.name).to eq(merchant_response_name)
    end
  end
end
