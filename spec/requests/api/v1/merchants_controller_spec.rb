require 'rails_helper'

RSpec.describe 'Api::V1::MerchantsController', type: :request do
  describe 'get api/v1/merchants' do
    it 'returns all merchants' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(3)

      merchants.each do |m|
        expect(m).to have_key(:id)
        expect(m[:attributes]).to have_key(:name)
      end
    end
  end

  describe 'get api/v1/merchants/:id/' do 
    it 'returns a specific merchant' do 
      merchant_id = create_list(:merchant, 3)[1].id

      expect(Merchant.all.count).to eq(3)

      get "/api/v1/merchants/#{merchant_id}"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_response.count).to eq(1)

      merchant_name = merchant_response[:data][:attributes][:name]

      expect(merchant_name).to eq(Merchant.where(name: merchant_name).first.name)
    end
  end
end
