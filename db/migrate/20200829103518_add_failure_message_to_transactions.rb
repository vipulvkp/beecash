class AddFailureMessageToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :failure_message, :string
  end
end
