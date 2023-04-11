class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers, primary_key: :id do |t|
      t.index :id, unique: true
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
