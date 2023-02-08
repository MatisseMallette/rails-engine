# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::ItemsControllers', type: :request do
  describe 'get api/v1/items' do
    it 'returns all items' do
      m1 = create(:merchant)
      create_list(:item, 3, merchant_id: m1.id)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(items.count).to eq(3)

      items.each do |i|
        expect(i).to have_key(:id)
        expect(i[:attributes]).to have_key(:name)
        expect(i[:attributes]).to have_key(:description)
        expect(i[:attributes]).to have_key(:unit_price)
        expect(i[:attributes]).to have_key(:merchant_id)
      end
    end
  end

  describe 'get api/v1/items/:id' do
    it 'returns a single item' do
      m1 = create(:merchant)
      i1 = create_list(:item, 3, merchant_id: m1.id)[1]

      get "/api/v1/items/#{i1.id}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)[:data]

      item.first do |i|
        expect(i).to have_key(:id)
        expect(i[:attributes]).to have_key(:name)
        expect(i[:attributes]).to have_key(:description)
        expect(i[:attributes]).to have_key(:unit_price)
        expect(i[:attributes]).to have_key(:merchant_id)
      end
    end
  end

  describe 'post api/v1/items' do
    it 'creates a new item' do
      m1 = create(:merchant)

      item_params = { name: 'Thing',
                      description: 'Thing Description',
                      unit_price: 100,
                      merchant_id: m1.id }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      created_item = Item.last

      expect(created_item.id).to eq(Item.last.id)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(100)
      expect(created_item.merchant_id).to eq(m1.id)
    end
  end

  describe 'delete api/v1/items/:id' do
    it 'deletes an item' do
      m1 = create(:merchant)
      item = create_list(:item, 3, merchant_id: m1.id)[1]

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful

      expect(Item.exists?(id: item.id)).to eq(false)

      deleted_item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(deleted_item[:id]).to eq(item.id.to_s)

      attributes = deleted_item[:attributes]

      expect(attributes[:name]).to eq(item.name)
      expect(attributes[:description]).to eq(item.description)
      expect(attributes[:unit_price]).to eq(item.unit_price)
      expect(attributes[:merchant_id]).to eq(m1.id)
    end
  end

  describe 'patch api/v1/items/:id' do
    it 'updates an item' do
      m1 = create(:merchant)
      item = create_list(:item, 3, merchant_id: m1.id)[1]

      item_params = { name: 'Thing',
                      description: 'Thing Description',
                      unit_price: 100,
                      merchant_id: m1.id }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      updated_item = Item.find(item.id)

      expect(updated_item.id).to eq(updated_item.id)
      expect(updated_item.name).to eq(item_params[:name])
      expect(updated_item.description).to eq(item_params[:description])
      expect(updated_item.unit_price).to eq(100)
      expect(updated_item.merchant_id).to eq(m1.id)
    end
  end
end
