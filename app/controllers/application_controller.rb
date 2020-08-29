class ApplicationController < ActionController::API
rescue_from ActiveRecord::RecordNotFound, with: :data_not_found
rescue_from JWT::DecodeError, with: :handle_decode_error
rescue_from ActiveRecord::RecordNotUnique, with: :handle_already_existing_records 

def set_user_id
      bearer_token = request.headers['Authorization'].split(' ').last
      raise "InValid UserID" if bearer_token.nil?
      decoded_data = JWT.decode bearer_token, SIGN_IN_SECRET , true, { algorithm: 'HS256' }
      raise JWT::DecodeError if decoded_data.first["user_id"].blank?
      @user_id = decoded_data.first["user_id"]
end

private
def data_not_found
     render json: {msg: "Requested Entity cannot be found"}
end

def handle_decode_error
    render json: {msg: "Sorry User cannot be authenticated for this operation"}
end

def handle_already_existing_records
   render json: {msg: "Record with the combination already exists"}
end
end
