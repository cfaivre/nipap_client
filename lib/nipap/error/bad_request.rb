require_relative 'client_error'

module Nipap
  class Error
    # Raised when Nipap returns the HTTP status code 400
    class BadRequest < Nipap::Error::ClientError
      HTTP_STATUS_CODE = 400
    end
  end
end
