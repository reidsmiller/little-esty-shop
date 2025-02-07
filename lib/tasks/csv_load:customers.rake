require 'csv'

namespace :csv_load do
  desc "Imports data from customers.csv"
  task :customers => :environment do

    CSV.foreach("db/data/customers.csv", headers: true) do |row|
        Customer.create!(row.to_h)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end
end