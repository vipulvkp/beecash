class ChangeTransactionTypeIdToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :transactions, :transaction_type_id, :integer
  end
end
