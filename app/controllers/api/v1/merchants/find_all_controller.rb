class Api::V1::Merchants::FindAllController < ApplicationController
  before_action :find_merchants
  def index
    if !@merchants.nil?
      render json: MerchantSerializer.new(@merchants)
    else
      render json: ErrorSerializer.no_data, status: :bad_request
    end
  end

  private

  def merchant_params
    params.permit(:name)
  end

  def find_merchants
    @merchants = Merchant.where("name ILIKE (?)", "%#{merchant_params[:name]}%")
  end
end
