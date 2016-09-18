require 'forwardable'
require_relative 'default'
require_relative 'error/configuration_error'

module Nipap
  module Configurable
    extend Forwardable
    attr_writer :username, :password
    attr_accessor :endpoint, :connection_options, :middleware, :logger
    def_delegator :options, :hash

    class << self

      def keys
        @keys ||= [
          :username,
          :password,
          :endpoint,
          :connection_options,
          :middleware,
          :logger,
        ]
      end

    end

    # Convenience method to allow configuration options to be set in a block
    #
    # @raise [Nipap::Error::ConfigurationError] Error is raised when supplied
    #   hermes credentials are not a String or Symbol.
    def configure
      yield self
      validate_credential_type!
      self
    end

    def reset!
      Nipap::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Nipap::Default.options[key])
      end
      self
    end
    alias setup reset!

    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

  private

    # @return [Hash]
    def credentials
      {
        :username => @username,
        :password => @password,
      }
    end

    # @return [Hash]
    def options
      Hash[Nipap::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    # Ensures that all credentials set during configuration are of a
    # valid type. Valid types are String and Symbol.
    #
    # @raise [Nipap::Error::ConfigurationError] Error is raised when
    #   supplied hermes credentials are not a String or Symbol.
    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil?

        unless value.is_a?(String) || value.is_a?(Symbol)
          raise(Error::ConfigurationError, "Invalid #{credential} specified: #{value} must be a string or symbol.")
        end
      end
    end

  end
end
