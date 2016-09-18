require_relative '../error'

module Nipap
  class Error
    # Raised when JSON parsing fails
    class DecodeError < Nipap::Error
    end
  end
end
