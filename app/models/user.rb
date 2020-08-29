class User < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :transactions, dependent: :destroy
  validates :name, :email, :phone_number, :password, :balance,  presence: true 
  def get_signed_token
    payload = {user_id: self.id, email: self.email}
    JWT.encode payload, SIGN_IN_SECRET, 'HS256'
  end


  def get_paginated_transactions(filter_params, page_number, page_size)
    offset = (page_number - 1) * page_size
    self.transactions.select(:id,:status, :amount, :user_id, :contact_id, :transaction_type_id, :created_at).where(filter_params).
    limit(page_size).
    offset(offset).
    order("created_at desc")
  end
end
