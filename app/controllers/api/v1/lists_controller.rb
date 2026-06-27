class Api::V1::ListsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_list, only: %i[ show update destroy ]

  def index
    @lists = List.order(:created_at)
  end

  def show
  end

  def create
    @list = List.new(list_params)

    if @list.save
      render :show, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def update
    if @list.update(list_params)
      render :show
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
  end

  private
  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.permit(:name)
  end
end
