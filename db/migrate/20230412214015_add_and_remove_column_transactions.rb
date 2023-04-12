class AddAndRemoveColumnTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column(:transactions, :result)
    add_column(:transactions, :result, :integer)
  end
end
