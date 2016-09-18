require_relative 'client_error'

module Nipap
  class Error
    # Raised when Nipap returns the HTTP status code 404
    class NotFound < Nipap::Error::ClientError
      HTTP_STATUS_CODE = 404
    end
  end
end
