class Merchant::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = BulkDiscount.merchant_bulk_discounts(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    if bulk_discount.save
      flash[:notice] = 'Discount Successfully Created'
      redirect_to merchant_bulk_discounts_path(merchant)
    else
      flash[:notice] = 'Discount Not Created: Invalid Input'
      redirect_to new_merchant_bulk_discount_path(merchant)
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount_percent, :quantity_threshold, :merchant_id)
  end
end