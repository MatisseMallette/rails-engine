require 'rails_helper'

RSpec.describe 'Api::V1::Merchants::FindAllController', type: :request do
  describe 'get api/v1/merchants/find_all' do
    # TODO: SAD PATH TESTING
    it 'returns specific merchants when given a name' do
      create_list(:merchant, 7, name: 'Habibi')
      m1 = create(:merchant, name: 'Jerome')
      m2 = create(:merchant, name: 'Jeff')
      m3 = create(:merchant, name: 'jeremy')
      m4 = create(:merchant, name: 'jenny')
      m5 = create(:merchant, name: 'robocop')

      get "/api/v1/merchants/find_all?name=Je"

      expect(response).to be_successful

      merchants_data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants_data.count).to eq(4)

      [m1, m2, m3, m4].each.with_index(0) do |merchant, index|
        m_d = merchants_data[index]
        expect(m_d).to have_key(:id)
        expect(m_d[:id]).to eq(merchant.id.to_s)
        expect(m_d[:attributes][:name]).to eq(merchant.name)
      end
    end
  end
end