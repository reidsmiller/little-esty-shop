class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions, primary_key: :id do |t|
      t.index :id, unique: true
      t.references :invoice, foreign_key: true
      t.integer :credit_card_number
      t.string :credit_card_expiration_date
      t.string :result

      t.timestamps
    end
  end
end
