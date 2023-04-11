require 'csv'

namespace :csv_load do
  desc "Imports data from invoice_items.csv"
  task :invoice_items => :environment do

    CSV.foreach("db/data/invoice_items.csv", headers: true) do |row|
        InvoiceItem.create!(row.to_h)
    end
  end
end