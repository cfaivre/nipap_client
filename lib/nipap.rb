require_relative 'nipap/client'
require_relative 'nipap/configurable'
require_relative 'nipap/default'
require_relative 'nipap/mail'
require_relative 'nipap/sms'

module Nipap
  class << self
    include Nipap::Configurable

    # Delegate to a Nipap::Client
    #
    # @return [Nipap::Client]
    def client
      @client = Nipap::Client.new(options) unless defined?(@client) && @client.hash == options.hash
      @client
    end

    # Has a client been initialized on the Nipap module
    #
    # @return [Boolean]
    def client?
      !!@client
    end

    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end
end

Nipap.setup
