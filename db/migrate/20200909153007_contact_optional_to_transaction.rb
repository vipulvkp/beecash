class ContactOptionalToTransaction < ActiveRecord::Migration[6.0]
  def change
    change_column_null :transactions, :contact_id, true
  end
end
