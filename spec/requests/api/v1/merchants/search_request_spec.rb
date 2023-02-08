require 'rails_helper'

RSpec.describe 'Api::V1::Merchants::Searches', type: :request do
  describe 'happy path' do
    describe 'merchants/find?name' do
      it 'returns a merchant based on name' do
        create_list(:merchant, 3)

        get "/api/v1/merchants/find?name=#{Merchant.first.name}"

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        merchant = data[:data]

        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to eq(Merchant.first.id)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to eq(Merchant.first.name)
      end
    end

    describe 'merchants/find_all?name' do
      it 'returns all merchant based on name' do
        create_list(:merchant, 9, name: 'Todd')
        target_merchants = create_list(:merchant, 3, name: 'Jeff')

        get '/api/v1/merchants/find_all?name=je'

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        merchants = data[:data]

        merchants.each.with_index do |merchant, index|
          expect(merchant).to have_key(:id)
          expect(merchant[:id].to_i).to eq(target_merchants[index].id)

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to eq(target_merchants[index].name)
        end
      end
    end
  end

  describe 'sad path' do
    describe 'merchants/find?name' do
      it 'returns nil if name does not match' do
        create_list(:merchant, 3)

        get '/api/v1/merchants/find?name=12345'

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:data]).to eq({})
      end
    end
  end
end
