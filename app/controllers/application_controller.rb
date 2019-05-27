class ApplicationController < ActionController::API
  include Error::ErrorHandler

  def represent_response raw_response
    render json: { status: true, data: raw_response.as_json }, status: Settings.http_code.code_201
  end

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    @decoded = JsonWebToken.decode header
    @current_user = User.find_by id: @decoded[:user_id]
  end
end
