module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :email, String, null: true
    field :phone_number, String, null: true
    field :password, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :balance, Integer, null: true
    field :contacts, [Types::ContactType], null: true
    field :transactions, [Types::TransactionGraphType], null: true do
      argument :transaction_type, String, required: false
      argument :contact_id, ID, required: false
      argument :page_size, Integer, required: false
      argument :page_number, Integer, required: false
    end

    def transactions(input={}) 
      filter = {}
      filter[:transaction_type_id] = TransactionType.find_by(name: input[:transaction_type].downcase).id if input[:transaction_type].present?
      filter[:contact_id] = input[:contact_id] if input[:contact_id].present? 
      get_page_number = (input[:page_number].present?) ? input[:page_number].to_i : 1  
      get_page_size = (input[:page_size].present?) ? input[:page_size].to_i : 50
      object.get_paginated_transactions(filter, get_page_number, get_page_size)
    end
  end
end
