class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :contact, optional: true
  enum transaction_type_id: { credit: 1, debit: 2}
end
