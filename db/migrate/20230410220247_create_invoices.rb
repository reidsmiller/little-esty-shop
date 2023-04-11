class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices, primary_key: :id do |t|
      t.index :id, unique: true
      t.references :customer, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
