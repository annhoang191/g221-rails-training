class ApplicationController < ActionController::API
  include Error::ErrorHandler

  def represent_response raw_response, status_code = Settings.http_code.code_201
    render json: { status: true, data: raw_response.as_json }, status: status_code
  end

  def authorize_request
    header = request.headers["Authorization"]
    raise Error::UnauthorizedError.new unless header

    header = header.split(" ").last
    @decoded_token = JsonWebToken.decode header
  end

  def current_user
    @current_user ||= User.cache_current_user(@decoded_token[:user_id])
  end
end
