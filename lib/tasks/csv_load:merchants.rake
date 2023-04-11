require 'csv'

namespace :csv_load do
  desc "Imports data from merchants.csv"
  task :merchants => :environment do

    CSV.foreach("db/data/merchants.csv", headers: true) do |row|
        Merchant.create!(row.to_h)
    end
  end
end