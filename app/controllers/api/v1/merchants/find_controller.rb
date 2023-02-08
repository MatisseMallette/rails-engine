class Api::V1::Merchants::FindController < ApplicationController
  before_action :find_merchant
  def index
    if !params[:name].nil? && !params[:name].empty?
      if !@merchant.nil?
        render json: MerchantSerializer.new(@merchant)
      else
        render json: ErrorSerializer.no_data, status: :bad_request
        # render json: MerchantSerializer.new(@merchant)
      end
    else
      render json: ErrorSerializer.no_data, status: :bad_request
    end
  end

  private

  def find_merchant
    @merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").first
  end
end
