require 'swagger_helper'

describe 'Users API' do

  path '/users' do

    get 'Returns all the users in the system. Users are our end users' do
      tags 'Users'
      produces 'application/json'
      response '200', 'lists all the users' do
        schema type: :object,
          properties: {
            id: { type: :integer, description: 'Id of the user'  },
            email: { type: :string , description: 'Email of the user'},
            name: { type: :string, description: 'Name of the user' },
        }
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
          name: { type: :string, description: 'Name of user' },
          email: { type: :string , description: 'Email of user'},
          phone_number: { type: :string, description: 'Phone number of user' },
          password: { type: :string, description: 'Some random password just to mimic sign up' },
          balance: { type: :integer, description: 'Every user will have a balance to start with'}
        },
        required: [ 'name', 'email','phone_number','password','balance' ]
      }
     response '200', 'Returns the newly created user id along with its signed token. This signed token must be used for creating contacts and initiating transation as a bearer token' do
      schema type: :object,
          properties: {
            user_id: { type: :integer, description: 'Id of the user created' },
            auth_token: { type: :string , description: 'Signed Auth token . This auth token needs to be sent as bearer token for every operation that a user does' },
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
        schema type: :object,
          properties: {
            id: { type: :integer, description: 'Id of the user'},
            email: { type: :string, description: 'Email of the user' },
            name: { type: :string, description: 'Name of the user' },
        }
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
         user_id: {type: :integer, description: 'Id of the user'},
         auth_token: {type: :string, description: 'Signed auth token for the requested user'}
       }
     let(:user) { [{ id: '1', name: 'User1', email: 'user1@beecash.io' },  {id: '2', name: 'User2', email: 'user2@beecash.io' }] }
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
         id: {type: :integer, description: 'Id of the contact'},
         name: {type: :string, description: 'Name of the contact'},
         user_id: {type: :integer, description: 'User ID to which the contact belongs to'},
         phone_number: {type: :string, description: 'Phone number of the contact'}
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
          name: { type: :string, description: 'Name of the contact' },
          user_id: { type: :integer, description: 'User id to which the contact belongs to'  },
          phone_number: { type: :string , description: 'Phone number of the contact'},
        },
        required: [ 'name', 'phone_number' ]
      }
     response '200', 'Returns the newly created contact' do
      schema type: :object,
          properties: {
          id: {type: :integer, description: 'Id of the contact created'},
         name: {type: :string, description: 'Name of the contact'},
         user_id: {type: :integer, description: 'User Id to which the contact belongs to'},
         phone_number: {type: :string, description: 'Phone number of the contact'}
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
         id: {type: :integer, description: 'Id of the contact'},
         name: {type: :string, description: 'Name of the contact'},
         user_id: {type: :integer, description: 'User ID to which the contact belongs to'},
         phone_number: {type: :string, description: 'Phone number of the contact'}
       }
       let(:user) { { user_id: '1', auth_token: 'some_sample_encrypted_jwt_token', balance: 100} }
      run_test!
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

  path '/users/:id/transactions' do
    get 'Fetch all the transaction for a user' do
      tags 'Transactions'
      produces  'application/json'
      parameter name: :id, :in => :path, :type => :integer, description: 'User Id for which transaction are required',
      schema: {
        type: :object,
        properties: {
          transaction_type: { type: :string, description: 'Fetch transactions for one of the allowed transaction types: Debit | Credit' },
          contact_id: { type: :integer, description: 'Fetch transactions for this particular contact id' },
          page_number: { type: :integer, description: 'Pagination supported through page number. If not given, page_number will be 1' },
          page_size: { type: :integer, description: 'Pagination supported through page size. If not given, page size will be 50' },
        },
      }
      response '200', 'Successful response listing all the transactions' do
        schema type: :object ,
        properties: {
          status: { type: :string, description: 'Status of the transactions' },
          transaction_type_id: {type: :integer, description: 'transaction type id 1 for credit , 2 for debit'},
          amount: {type: :integer, description: 'Amount for the transaction'},
          user_id: {type: :integer, description: 'User id who initiated the transaction'},
          contact_id: {type: :integer, description: 'Contact id with which the transaction was done'},
          created_at: {type: :integer, description: 'Created Time stamp of the transaction'}
       }
      let(:transaction) { { id: 1, transaction_type_id: 1, user_id: 1, contact_id: 1, amount: 10, status: 'created'} }
      run_test!
      end
    end
  end
end
