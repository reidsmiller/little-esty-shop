# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Item.destroy_all
Customer.destroy_all
Merchant.destroy_all
BulkDiscount.destroy_all

customer1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
customer2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
customer3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
customer4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
customer5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')

merchant1 = Merchant.create!(name: 'Gladrags Wizardwear')
merchant2 = Merchant.create!(name: 'Bertie-Botts Every Flavor Beans')

BulkDiscount.create!(discount_percent: 0.15, quantity_threshold: 10, merchant_id: merchant1.id)
BulkDiscount.create!(discount_percent: 0.25, quantity_threshold: 20, merchant_id: merchant1.id)
BulkDiscount.create!(discount_percent: 0.10, quantity_threshold: 15, merchant_id: merchant2.id)

item1 = Item.create!(name: 'Hogwarts Robe', description: 'One-size-fits-all', unit_price: 3_000, merchant_id: merchant1.id)
item2 = Item.create!(name: 'Sneakoscope', description: 'Whistles when sneaky people are nearby', unit_price: 1_500, merchant_id: merchant1.id)
item3 = Item.create!(name: 'Cloak of Invisibility', description: 'The ultimate in stealth wear', unit_price: 30_000, merchant_id: merchant1.id)
item4 = Item.create!(name: 'Beans', description: 'Every flavor imaginable!', unit_price: 300, merchant_id: merchant2.id)

invoice1 = Invoice.create!(customer_id: customer1.id, status: 1)
invoice2 = Invoice.create!(customer_id: customer2.id, status: 1)
invoice3 = Invoice.create!(customer_id: customer3.id, status: 1)
invoice4 = Invoice.create!(customer_id: customer4.id, status: 1)
invoice5 = Invoice.create!(customer_id: customer5.id, status: 1)

InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 30, status: 1)
InvoiceItem.create!(item_id: item2.id, invoice_id: invoice1.id, quantity: 10, unit_price: 15, status: 1)
InvoiceItem.create!(item_id: item3.id, invoice_id: invoice2.id, quantity: 15, unit_price: 300, status: 1)
InvoiceItem.create!(item_id: item4.id, invoice_id: invoice2.id, quantity: 20, unit_price: 3, status: 1)
InvoiceItem.create!(item_id: item1.id, invoice_id: invoice3.id, quantity: 5, unit_price: 30, status: 1)
InvoiceItem.create!(item_id: item2.id, invoice_id: invoice3.id, quantity: 10, unit_price: 15, status: 1)
InvoiceItem.create!(item_id: item3.id, invoice_id: invoice4.id, quantity: 15, unit_price: 300, status: 1)
InvoiceItem.create!(item_id: item4.id, invoice_id: invoice4.id, quantity: 20, unit_price: 3, status: 1)
InvoiceItem.create!(item_id: item1.id, invoice_id: invoice5.id, quantity: 5, unit_price: 30, status: 1)

Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice1.id)
Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: invoice2.id)
Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: invoice3.id)
Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: invoice4.id)
Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: invoice5.id)