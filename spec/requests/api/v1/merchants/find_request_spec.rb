require 'rails_helper'

RSpec.describe 'Api::V1::FindController', type: :request do
  describe 'get api/v1/merchants/find?name=iLl' do
    it 'returns a specific merchants when given a name' do
      merchants = create_list(:merchant, 5)
      merchant = create(:merchant, name: 'Jeff')

      get "/api/v1/merchants/find?name=#{merchant.name}"

      expect(response).to be_successful

      merchant_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant_data).to have_key(:id)

      expect(merchant_data[:id]).to eq(Merchant.find(merchant.id).id.to_s)

      attributes = merchant_data[:attributes]

      expect(attributes[:name]).to eq(merchant.name)
    end

    it 'returns a specific merchants when given a name FRAGMENT' do
      merchants = create_list(:merchant, 5)
      merchant = create(:merchant, name: 'Jeff')

      get "/api/v1/merchants/find?name=jef"

      expect(response).to be_successful

      merchant_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant_data).to have_key(:id)

      expect(merchant_data[:id]).to eq(Merchant.find(merchant.id).id.to_s)

      attributes = merchant_data[:attributes]

      expect(attributes[:name]).to eq(merchant.name)
    end

    it 'returns an ERROR when no fragment matches' do
      merchants = create_list(:merchant, 5)
      merchant = create(:merchant, name: 'Jeff')

      get "/api/v1/merchants/find?name=NOMATCH"
      
      expect(response).to_not be_successful

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:data].nil?).to eq(false)
      expect(data[:data].empty?).to eq(true)
    end
  end
end
