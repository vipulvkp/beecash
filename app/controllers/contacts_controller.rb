class ContactsController < ApplicationController
  before_action :set_user_id
  
  def index
    @contacts = @user.contacts.select(:id, :name, :user_id, :phone_number)
    render json: @contacts
  end

  def show
    render json: @user.contacts.where(id: params[:id]).select(:id, :name, :user_id, :phone_number)
  end

  # POST /contacts
  def create
    # Pattern 1 of achieving idempotency
    # I have set a uniq compisite index/key on Contact table for user_id, phone_number, name. 
    # If another subsequent request tries to create the same record, it will not create duplicate records.
    # Can be used for patterns where A Create CTA button on front end is clicked multiple times to create the same record.
    @contact = Contact.new(contact_params.merge({user_id: @user.id}))
    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: 500 
    end
  end

  private
    def contact_params
      params.permit(:name,:phone_number)
    end
end
