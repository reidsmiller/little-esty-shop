class Merchant::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = Item.all
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

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.create(item_params)
     if @item.save
      flash[:notice] = "Item succesfully created"
      redirect_to merchant_items_path(@merchant)
     else
      flash[:alert] = "Item not created: description has to be at least 6 charachters long"
      redirect_to new_merchant_item_path(@merchant)
     end
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :status)
  end
end