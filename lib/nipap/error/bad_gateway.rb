require_relative 'server_error'

module Nipap
  class Error
    # Raised when Nipap returns the HTTP status code 502
    class BadGateway < Nipap::Error::ServerError
      HTTP_STATUS_CODE = 502
    end
  end
end
