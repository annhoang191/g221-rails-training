class ApplicationController < ActionController::API
  include Error::ErrorHandler

  def represent_response raw_response
    render json: { status: true, data: raw_response.as_json }, status: Settings.http_code.code_201
  end
end
