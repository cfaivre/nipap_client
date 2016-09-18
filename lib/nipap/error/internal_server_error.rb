require_relative 'server_error'

module Nipap
  class Error
    # Raised when Nipap returns the HTTP status code 500
    class InternalServerError < Nipap::Error::ServerError
      HTTP_STATUS_CODE = 500
      MESSAGE = "Something is technically wrong"
    end
  end
end
