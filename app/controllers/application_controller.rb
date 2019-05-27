class ApplicationController < ActionController::API
  include Error::ErrorHandler

  def represent_response raw_response
    render json: { status: true, data: raw_response.as_json }, status: Settings.http_code.code_201
  end

  def authorize_request
    header = request.headers["Authorization"]
    raise Error::UnauthorizedError.new unless header

    header = header.split(" ").last
    decoded_token = JsonWebToken.decode header

    @current_user = User.find decoded_token[:user_id]
  end
end
