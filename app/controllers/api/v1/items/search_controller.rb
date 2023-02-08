class Api::V1::Items::SearchController < ApplicationController

  def index
    if params[:min_price]
      return render json: ErrorSerializer.bad_data, status: :bad_request if params[:min_price].to_f < 0
    elsif params[:max_price]
      return render json: ErrorSerializer.bad_data, status: :bad_request if params[:max_price].to_f < 0
    end

    if (params[:name] && params[:name] != '') && (!params[:min_price] && !params[:max_price])
      set_items_by_name
      render json: ItemSerializer.new(@items)
    elsif (params[:min_price] || params[:max_price]) && (params[:min_price] != '' && params[:max_price] != '') && !params[:name]
      set_items_by_price
      render json: ItemSerializer.new(@items)
    else
      render json: ErrorSerializer.bad_data, status: :bad_request
    end
  end

  def show
    # if params[:min_price]
    #   return render json: ErrorSerializer.bad_data, status: :bad_request if params[:min_price].to_f < 0
    # elsif params[:max_price]
    #   return render json: ErrorSerializer.bad_data, status: :bad_request if params[:max_price].to_f < 0
    # end
    # if (params[:name] && params[:name] != '') && (!params[:min_price] && !params[:max_price])
    #   set_item_by_name
    #   render json: ItemSerializer.new(@item)
    # elsif (params[:min_price] || params[:max_price]) && (params[:min_price] != '' && params[:max_price] != '') && !params[:name]
    #   set_item_by_price
    #   render json: ItemSerializer.new(@item)
    # else
    #   render json: ErrorSerializer.bad_data, status: :bad_request
    # end

    if params[:name] && !params[:name].empty?
      set_item_by_name
      if @item.nil?
        render json: ErrorSerializer.no_data
      else
        render json: ItemSerializer.new(@item)
      end
    else
      render json: ErrorSerializer.bad_data, status: :bad_request
    end
  end

  private

  def set_item_by_name
    @item = Item.find_by_name(params[:name])
  end

  # def set_item_by_price
  #   @item = Item.find_by_price(params[:name])
  # end

  def set_items_by_name
    @items = Item.find_all_by_name(params[:name])
  end

  def set_items_by_price
    @items = Item.find_all_by_price(params[:min_price], params[:max_price])
  end
end
