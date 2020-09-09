class TransactionsController < ApplicationController
  before_action :set_user_id, only: [:show]

  def show
    render json: @user.get_paginated_transactions(filter_params, get_page_number, get_page_size)
  end

  private

  def filter_params
   obj = {}
   obj[:transaction_type_id] = Transaction.transaction_type_ids[params[:transaction_type].downcase] if params[:transaction_type].present?
   obj[:contact_id] = params[:contact_id] if params[:contact_id].present?
   obj
  end

  def get_page_number
    (params[:page_number].present?) ? params[:page_number].to_i : 1
  end

  def get_page_size
    (params[:page_size].present?) ? params[:page_size].to_i : 50
  end
  
end
