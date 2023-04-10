class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants, primary_key: :id do |t|
      t.index :id, unique: true
      t.string :name

      t.timestamps
    end
  end
end
