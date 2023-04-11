class CreateInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items, primary_key: :id do |t|
      t.index :id, unique: true
      t.references :item, foreign_key: true
      t.references :invoice, foreign_key: true
      t.integer :quantity
      t.integer :unit_price
      t.string :status

      t.timestamps
    end
  end
end
