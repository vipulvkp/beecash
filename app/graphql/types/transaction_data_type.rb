module Types
  class TransactionDataType < Types::BaseObject
    field :data, [Types::TransactionGraphType], null: false
    field :has_next_page, Boolean, null: false
  end
end
