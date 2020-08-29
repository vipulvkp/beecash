require 'swagger_helper'

describe 'Users API' do

  path '/users' do

    get 'Returns all the users in the system. Users are our end users' do
      tags 'Users'
      produces 'application/json'
      response '200', 'lists all the users' do
        let(:user) { [{ id: '1', name: 'User1', email: 'user1@beecash.io' },  {id: '2', name: 'User2', email: 'user2@beecash.io' }] }
        run_test!
      end
    end

    post 'Creates a user in our system. Treat it like a user himself signups with our system. The apis is http authenticated protected. Username/password is admin/admin' do
     tags 'Users'
     consumes 'application/json'
     produces 'application/json'
     parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          phone_number: { type: :string },
          password: { type: :string },
          balance: { type: :integer }
        },
        required: [ 'name', 'email','phone_number','password','balance' ]
      }
     response '200', 'Returns the newly created user id along with its signed token. This signed token must be used for creating contacts and initiating transation as a bearer token' do
      schema type: :object,
          properties: {
            user_id: { type: :integer, },
            auth_token: { type: :string },
      }
      let(:user) { { user_id: '1', auth_token: 'some_sample_encrypted_jwt_token', balance: 100} }
      run_test!
     end
   end
    
  end
 
 path '/users/:id' do
   get 'Returns a specific user in our system. Users are our end users' do
     tags 'Users'
     produces 'application/json'
     parameter name: :id, :in => :path, :type => :integer
     response '200', 'displays the specific user' do
        let(:user) { { id: '1', name: 'User1', email: 'user1@beecash.io' } }
        run_test!
      end 
   end
 end

 path '/get_user_token/:id' do
   get 'Returns signed token for a user. Providing this api just to fetch the signed token for a user whenver needed' do
     tags 'Users'
     produces 'application/json' 
     parameter name: :id, :in => :path, :type => :integer
     response '200', 'Returns signed auth token for a user id' do
       schema type: :object ,
       properties: {
         user_id: {type: :integer},
         auth_token: {type: :string}
       }
     end
   end
 end
end

describe 'Contacts API' do
  path '/contacts' do

    get 'Returns all the contacts for a user. The user id is fetched from the signed authentication token which needs to be passed in the Bearer' do
      tags 'Contacts'
      produces 'application/json'
      response '200', 'lists all the contacts' do
        schema type: :object ,
        properties: {
         id: {type: :integer},
         name: {type: :string},
         user_id: {type: :integer},
         phone_number: {type: :string}
       } 
        let(:user) { [{ id: '1', name: 'User1', email: 'user1@beecash.io' },  {id: '2', name: 'User2', email: 'user2@beecash.io' }] }
        run_test!
      end
    end

    post 'Creates a contact belonging to a user in our system. The user id is fetched from the signed authentication token which needs to be passed in the Bearer' do
     tags 'Contacts'
     consumes 'application/json'
     produces 'application/json'
     parameter name: :contact, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          user_id: { type: :integer },
          phone_number: { type: :string },
        },
        required: [ 'name', 'phone_number' ]
      }
     response '200', 'Returns the newly created contact' do
      schema type: :object,
          properties: {
          id: {type: :integer},
         name: {type: :string},
         user_id: {type: :integer},
         phone_number: {type: :string}
      }
      let(:user) { { user_id: '1', auth_token: 'some_sample_encrypted_jwt_token', balance: 100} }
      run_test!
     end
   end
   end

   path '/contacts/:id' do
    get 'Returns a specific contact for a user. The user id is fetched from the signed authentication token which needs to be passed in the Bearer' do
      tags 'Contacts'
      produces 'application/json'
      response '200', 'lists specific contact for the user' do
        schema type: :object ,
        properties: {
         id: {type: :integer},
         name: {type: :string},
         user_id: {type: :integer},
         phone_number: {type: :string}
       }
      end        
    end
   end
end

describe 'Transactions API' do
  path '/initiate_transaction' do
    post 'Intiate a transaction to a contact. The user id which initiates the transaction is fetched from the signed authentication token which needs to be passed in the Bearer' do
      tags 'Transactions'
      consumes 'application/json'
      produces  'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          transaction_type: { type: :string, description: 'Allowed values: debit | credit' },
          contact_id: { type: :integer, description: 'contact_id to which transaction needs to be done' },
          amount: { type: :integer, description: 'amount for transaction' },
        },
        required: [ 'transaction_type', 'contact_id', 'amount']
      }
      response '200', 'Successfull creation of transaction' do
        schema type: :object ,
        properties: {
         message: {type: :string, description: 'A string message highlighting if the transaction was successfull or failure'},
       }
      let(:transaction) { { id: 1, transaction_type_id: 1, user_id: 1, contact_id: 1, amount: 10, status: 'created'} }
      run_test!
      end
    end
  end
end
