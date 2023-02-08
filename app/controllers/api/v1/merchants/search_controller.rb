class Api::V1::Merchants::SearchController < ApplicationController

  def index
    set_merchants_by_name
    render json: MerchantSerializer.new(@merchants)
  end

  def show
    if params[:name] && !params[:name].empty?
      set_merchant_by_name
      if @merchant.nil?
        render json: ErrorSerializer.no_data
      else
        render json: MerchantSerializer.new(@merchant)
      end
    else
      render json: ErrorSerializer.bad_data, status: :bad_request
    end
  end

  private

  def set_merchant_by_name
    @merchant = Merchant.find_by_name(params[:name])
  end

  def set_merchants_by_name
    @merchants = Merchant.find_all_by_name(params[:name])
  end
end
