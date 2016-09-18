require_relative 'client_error'

module Nipap
  class Error
    # Raised when Nipap returns the HTTP status code 403
    class Forbidden < Nipap::Error::ClientError
      HTTP_STATUS_CODE = 403
    end
  end
end
