require 'csv'

namespace :csv_load do
  desc "Imports data from all csv files"
  task :all => :environment do

    CSV.foreach("db/data/customers.csv", headers: true) do |row|
      Customer.create!(row.to_h)
    end

    CSV.foreach("db/data/merchants.csv", headers: true) do |row|
      Merchant.create!(row.to_h)
    end

    CSV.foreach("db/data/invoices.csv", headers: true) do |row|
      Invoice.create!(row.to_h)
    end

    CSV.foreach("db/data/items.csv", headers: true) do |row|
      Item.create!(row.to_h)
    end

    CSV.foreach("db/data/invoice_items.csv", headers: true) do |row|
      InvoiceItem.create!(row.to_h)
    end

    CSV.foreach("db/data/transactions.csv", headers: true) do |row|
      Transaction.create!(row.to_h)
    end
    
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end
end