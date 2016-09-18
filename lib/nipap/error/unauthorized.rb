require_relative 'client_error'

module Nipap
  class Error
    # Raised when Nipap returns the HTTP status code 401
    class Unauthorized < Nipap::Error::ClientError
      HTTP_STATUS_CODE = 401
    end
  end
end
