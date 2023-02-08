class Api::V1::Merchants::ItemsController < ApplicationController
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
