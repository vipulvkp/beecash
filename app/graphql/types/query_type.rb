module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false
    field :user, Types::UserType, null: false do
      argument :id, ID, required: true 
    end
   
    def users 
      User.select(:id,:email,:name).all
    end

    def user
      User.select(:id,:email,:name).find(params[:id]) 
    end

  end
end
