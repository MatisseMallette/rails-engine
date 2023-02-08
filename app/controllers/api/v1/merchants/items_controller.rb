# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class ItemsController < ApplicationController
        before_action :find_merchant
        def index
          render json: ItemSerializer.new(Item.where(merchant_id: @merchant.id))
        end

        private

        def find_merchant
          if Merchant.exists?(id: params[:merchant_id])
            @merchant = Merchant.find(params[:merchant_id])
          else
            render json: ErrorSerializer.bad_data, status: :not_found
          end
        end
      end
    end
  end
end
