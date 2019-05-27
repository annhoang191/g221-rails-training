module Error
  module ErrorHandler
    include Error::GroupError
    extend ActiveSupport::Concern

    included do
      # Fallback rescue for unexpected errors, return error 500
      rescue_from(*INTERNAL_ERROR_GROUP) do |e|
        respond error_code(e), error_message(e), e.message, Settings.http_code.code_500
      end

      # Group for 400 Bad Request error
      rescue_from(*BAD_REQUEST_ERROR_GROUP) do |e|
        respond error_code(e), error_message(e), e.message, Settings.http_code.code_400
      end

      # Group for 404 Not Found error
      rescue_from(*NOT_FOUND_ERROR_GROUP) do |e|
        respond error_code(e), error_message(e), e.message, Settings.http_code.code_404
      end

      rescue_from(*UNAUTHORIZE_ERROR_GROUP) do |e|
        respond error_code(e), error_message(e), e.message, Settings.http_code.code_401
      end
    end

    private

    def respond error_code, message, errors, status_code
      render json: { status: false, error: { error_code: error_code, message: message, errors: errors } }, status: status_code
    end

    def error_key error
      error.class.name.split("::").drop(1).map(&:underscore).last
    end

    def error_message error
      I18n.t("api_error.error_message.#{error_key(error)}")
    end

    def error_code error
      Settings.api_errors.error_codes.public_send error_key(error)
    end
  end
end
