require 'csv'

namespace :csv_load do
  desc "Imports data from transactions.csv"
  task :transactions => :environment do

    CSV.foreach("db/data/transactions.csv", headers: true) do |row|
        Transaction.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end
end