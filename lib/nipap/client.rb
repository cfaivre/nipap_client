require 'faraday'
require 'multi_json'
require_relative 'configurable'
require_relative 'api/mails'
require_relative 'api/sms'
require_relative 'error/client_error'
require_relative 'error/decode_error'

module Nipap

  class Client
    include Nipap::API::Mails
    include Nipap::API::Sms
    include Nipap::Configurable

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Nipap::Client]
    def initialize(options={})
      Nipap::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Nipap.instance_variable_get(:"@#{key}"))
      end
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

   # Perform an HTTP POST request
    def post(path, payload={})
      request(:post, path, payload)
    end

    # Returns a proc that can be used to setup the Faraday::Request headers
    #
    # @return [Proc]
    def request_setup()
      Proc.new do |request|
        request.headers[:authorization] = basic_auth_header
        request.headers[:content_type] = 'application/json; charset=UTF-8'
        request.headers[:accept] = 'application/json; charset=UTF-8'
      end
    end

    def request(method, path, payload={} )
      request_headers = request_setup
      connection.send(method.to_sym, path, payload, &request_headers).env
    rescue Faraday::Error::ClientError
      logger.error "Nipap::Client : error while processing #{method.upcase} #{path.to_s} #{payload.to_json}"
      raise Nipap::Error::ClientError
    rescue decode_exception
      logger.error "Nipap::Client : json decode error while processing #{method.upcase} #{path.to_s} #{payload.to_s}"
      raise Nipap::Error::DecodeError
    end

    def basic_auth_header
      basic_auth_token  = encode_value("#{@username}:#{@password}")
      "Basic #{basic_auth_token}"
    end

    def encode_value(value)
      [value].pack("m0") #.gsub("\n", '')
    end

    def decode_exception
      defined?(MultiJson::ParseError) ? MultiJson::ParseError : MultiJson::DecodeError
    end

  end

end

