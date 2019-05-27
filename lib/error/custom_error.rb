module Error
  # Subclass from CustomError to define your own error
  class CustomError < StandardError
    attr_reader :message

    def initialize
      error_key = self.class.name.split("::").drop(1).map(&:underscore).last
      @message = I18n.t("api_error.error_detail.#{error_key}")
    end
  end

  class UnauthorizedError < CustomError; end
end
