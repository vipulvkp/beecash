module Types
  class QueryType < Types::BaseObject

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true 
    end
   
    def user(input={})
      User.find(input[:id]) 
    end

  end
end
