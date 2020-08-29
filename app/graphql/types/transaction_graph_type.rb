module Types
  class TransactionGraphType < Types::BaseObject
    field :id, ID, null: false
    field :transaction_type_id, Integer, null: true
    field :status, String, null: true
    field :amount, Integer, null: true
    field :user_id, Integer, null: false
    field :contact_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :failure_message, String, null: true
  end
end
