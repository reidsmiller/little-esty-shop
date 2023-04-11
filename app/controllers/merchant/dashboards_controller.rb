class Merchant::DashboardsController < ApplicationController
  def show
    @merchant = Merchant.find(params[:id])
  end
end