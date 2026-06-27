class Api::V1::ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_list
  before_action :set_item, only: %i[ show update destroy ]

  def index
    @items = Item.where(list_id: @list.id)
  end

  def show
  end

  def create
    @item = @list.items.new(item_params)

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render :show
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
  end

  private

  def set_list
    @list = List.find_by(id: params[:list_id])
  end

  def set_item
    @item = Item.find_by(id: params[:id])
  end

  def item_params
    params.permit(:value, :description)
  end
end
