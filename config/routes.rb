Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #################### Routes for Users -> who are the end users of this app ###########
  get "/users", to: "users#index" 
  get "/users/:id", to: "users#show"
  post "/users", to: "users#create"
  get "/get_user_token/:id", to: "users#get_user_token"

###################### Routes for initiating transaction by a user to a contact ###################
  post "initiate_transaction", to: "users#initiate_transaction"

#################### Routes for contacts which are created by an authenticated user ###################
  get "/contacts", to: "contacts#index" 
  get "/contacts/:id", to: "contacts#show"
  post "/contacts", to: "contacts#create"

#################### Routes for transactions for a user ########################### 
  get "/users/:id/transactions" , to: "transactions#show"
end
