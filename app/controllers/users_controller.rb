class UsersController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :set_user_for_show, only: [:show, :get_user_token]
  before_action :http_authenticate, only: [:create, :get_user_token]
  before_action :set_user_id, only: [:initiate_transaction]
  before_action :verify_transaction_params, only: [:initiate_transaction]

  def index
    @users = User.select(:id,:email,:name).all
    render json: @users
  end

  def show
    render json: @user
  end

  def create

    # Pattern 2 of achieving idempotency
    # In pattern 1 which I commented in contacts controller, we have used uniq constraint to prevent duplicates
    # In this pattern, we can have a simple find and create by appraoch. If record alredy exists, we just render a back simple json , thereby not creating duplicates.

    if User.find_by(name: user_params[:name], email: user_params[:email], phone_number: user_params[:phone_number]).present?
      render json: {msg: "Hey admin. This user already exists"} if User.find_by(name: user_params[:name], email: user_params[:email], phone_number: user_params[:phone_number]).present?
    else
      user_params[:password] = Base64.encode64(user_params[:password])
      @user = User.new(user_params)
      if @user.save
	render json: {user_id: @user.id, auth_token: @user.get_signed_token} , status: :created
      else
	render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def initiate_transaction

     # Pattern 3 of achiveing Idempotence which is Idempotency + Atomicity
     # Two subsequent requests can be made by the same user to debit/credit to a contact which is a valid scenario
     # These two subsequent requests will end up creating two different transaction records
     # However, we need to make sure when subsequent requests are made in a very short duration then they might end up to be concurrent,
     # In concurrent transactions, atomicity and race conditions needs to be taken care of.
     # Using database isolation levels and lock wait policies we can achieve this

     txn = Transaction.create(
     trasaction_type_id: params[:transaction_type],
     status: "created",
     user_id: @user.id,
     contact_id: params[:contact_id] ,
     amount: params[:amount]
     )
     ActiveRecord::Base.transaction(isolation: :read_committed) do
     begin
       contact = Contact.lock("FOR UPDATE NOWAIT").find(params[:contact_id])
       txn.update_attributes(status: "in_progress")
       contact.initiate_transaction(params[:transaction_type], params[:amount])
       txn.update_attributes(status: "completed")
       render json: {message: "successfull"}, status: 200
     rescue StandardError => e
      txn.update_attributes(status: "failed", failure_message: e.message[0..200])
      render json: {message: "Error While transaction. Please try again"}, status: 500
     end 
     end
  end

  def get_user_token
    render json: {user_id: @user.id,  auth_token: @user.get_signed_token}
  end

  private
    def set_user_for_show
      @user = User.select(:id,:email,:name).find(params[:id])
    end

    def user_params
      params.permit(:name, :email, :phone_number, :password, :balance)
    end

    def verify_transaction_params
      render json: {msg: "Invalid transaction type"} if params[:transaction_type].blank? or !["credit","debit"].include?(params[:transaction_type])
      render json: {msg: "Invalid amount given. Please give a positive amount for transfer"} if params[:amount].blank? or params[:amount]<=0
    end

    def http_authenticate
        authenticate_or_request_with_http_basic do |username, password|
            username == 'admin' && password == 'admin'
        end
    end

end
