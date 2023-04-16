class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(invoice_params)
    if (params[:invoice][:status] == "completed")
      invoice.update(status: 'completed')
    elsif (params[:invoice][:status] == "shipped")
      invoice.update(status: 'shipped')
    end
    redirect_to admin_invoice_path(invoice.id)
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status)
  end
end