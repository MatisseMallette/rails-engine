class Api::V1::Items::FindAllController < ApplicationController
  before_action :find_items
  def index
    if !@items.nil?
      render json: ItemSerializer.new(@items)
    else
      render json: ErrorSerializer.no_data, status: :bad_request
    end
  end

  private

  def item_params
    params.permit(:name, :min_price, :max_price)
  end

  def find_items
    if !params.include?(:name) && !params.include?(:min_price) && !params.include?(:max_price)
      render json: ErrorSerializer.bad_data, status: :bad_request
    else
      @items = name_items & min_price_items & max_price_items
    end
  end

  def name_items
    # this is stupid and limits the functionality. why not be able to add as much search criteria as you want?
    if item_params.include?(:name)
      if item_params.include?(:min_price) || item_params.include?(:max_price)
        render json: ErrorSerializer.bad_data, status: :bad_request
      elsif params[:name].empty?
        render json: ErrorSerializer.bad_data, status: :bad_request
      end
    end

    if !item_params[:name].nil? && !item_params[:name].empty?
      Item.where('name ILIKE (?)', "%#{item_params[:name]}%")
    else
      Item.all
    end
  end

  def min_price_items
    if !item_params[:min_price].nil? && !item_params[:min_price].empty?
      render json: ErrorSerializer.bad_data, status: :bad_request if params[:min_price].to_i <= 0
      Item.where('unit_price >= (?)', item_params[:min_price])
    else
      Item.all
    end
  end

  def max_price_items
    if !item_params[:max_price].nil? && !item_params[:max_price].empty?
      render json: ErrorSerializer.bad_data, status: :bad_request if params[:max_price].to_i <= 0
      Item.where('unit_price <= (?)', item_params[:max_price])
    else
      Item.all
    end
  end
end
