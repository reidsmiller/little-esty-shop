class Merchant::DashboardsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:id])
    @merchant_image = MerchantImageSearch.new.merchant_image
  end
end