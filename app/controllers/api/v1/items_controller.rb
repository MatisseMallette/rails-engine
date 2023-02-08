class Api::V1::ItemsController < ApplicationController
  before_action :find_item, only: :show
  before_action :return_if_nil, only: [:show, :update, :destroy]

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(Item.create(item_params)), status: :created
    else
      render json: ErrorSerializer.unprocessable(item.errors), status: :unprocessable_entity
    end
  end

  def update
    # TODO: Add sad path testing for everything in this controller
    if @item.update(item_params)
      render json: ItemSerializer.new(@item)
    else
      render json: ErrorSerializer.unprocessable(@item.errors), status: :not_found
    end
  end

  def destroy
    render json: ItemSerializer.new(@item.destroy)
  end

  private

  def return_if_nil
    find_item
    return if @item.nil?
  end

  def find_item
    if Item.exists?(id: params[:id])
      @item = Item.find(params[:id])
    else
      return render json: ErrorSerializer.bad_data, status: :not_found
    end
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
