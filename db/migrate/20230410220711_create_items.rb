class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items, primary_key: :id do |t|
      t.index :id, unique: true
      t.string :name
      t.text :description
      t.integer :unit_price
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
