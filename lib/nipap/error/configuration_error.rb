require_relative '../error'

module Nipap
  class Error
    class ConfigurationError < ::ArgumentError
    end
  end
end
