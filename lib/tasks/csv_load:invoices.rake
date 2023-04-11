require 'csv'

namespace :csv_load do
  desc "Imports data from invoices.csv"
  task :invoices => :environment do

    CSV.foreach("db/data/invoices.csv", headers: true) do |row|
        Invoice.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end
end