require_relative 'server_error'

module Nipap
  class Error
    # Raised when Nipap returns the HTTP status code 503
    class ServiceUnavailable < Nipap::Error::ServerError
      HTTP_STATUS_CODE = 503
      MESSAGE = "Nipap is over capacity"
    end
  end
end
