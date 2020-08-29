class AddUniqIndexToModels < ActiveRecord::Migration[6.0]
  def change
    add_index(:contacts, [:name, :phone_number, :user_id], unique: true)
    add_index(:transactions, [:contact_id, :user_id, :contact_id, :transaction_type_id, :status])
    add_index(:transactions, :user_id)
    add_index(:transactions, :transaction_type_id)
  end
end
