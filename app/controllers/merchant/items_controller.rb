class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to merchant_item_path(@merchant, @item) if item_params[:name].present?
      redirect_to merchant_items_path(@merchant) if item_params[:status].present?
      flash[:notice] = "Item Information Succesfully Updated"
    else
      flash[:alert] = "Item not updated: Required information not filled out or filled out incorrectly"
      redirect_to edit_merchant_item_path(@merchant, @item)
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :status)
  end
end