class Api::V1::ListsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_list, only: %i[ show update destroy ]

  # GET /lists
  def index
    @lists = List.order(:created_at)
  end

  # GET /lists/1
  def show
  end

  # POST /lists
  def create
    @list = List.new(list_params)

    if @list.save
      render :show, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lists/1
  def update
    if @list.update(list_params)
      render :show
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lists/1
  def destroy
    @list.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = List.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def list_params
    params.permit(:name)
  end
end
