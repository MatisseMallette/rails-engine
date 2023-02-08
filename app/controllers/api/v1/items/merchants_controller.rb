# frozen_string_literal: true

module Api
  module V1
    module Items
      class MerchantsController < ApplicationController
        def show
          item = Item.find(params[:item_id])
          render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
        end
      end
    end
  end
end
