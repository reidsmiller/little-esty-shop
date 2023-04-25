class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts, primary_key: :id do |t|
      t.index :id, unique: true
      t.references :merchant, foreign_key: true
      t.float :discount_percent
      t.integer :quantity_threshold

      t.timestamps
    end
  end
end
