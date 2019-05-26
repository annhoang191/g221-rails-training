module Error
  module GroupError
    INTERNAL_ERROR_GROUP = [
      StandardError, CustomError
    ].freeze

    BAD_REQUEST_ERROR_GROUP = [
      ActiveRecord::RecordInvalid
    ].freeze

    NOT_FOUND_ERROR_GROUP = [
      ActiveRecord::RecordNotFound
    ].freeze
  end
end
