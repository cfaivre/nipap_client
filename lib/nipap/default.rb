require 'faraday'
require 'faraday_middleware'
require_relative 'configurable'
require_relative 'error/client_error'
require_relative 'error/server_error'
require_relative 'response/parse_json'
require_relative 'response/raise_error'
require_relative 'version'
require 'logger'

module Nipap

  module Default

    ENDPOINT = 'https://nipap.avengers.hetzner.co.za' unless defined? Nipap::Default::ENDPOINT

    LOGGER = Logger.new STDOUT

    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/json',
        :user_agent => "Nipap Ruby Gem #{Nipap::Version}",
      },
      :request => {
        :open_timeout => 10,
        :timeout => 20,
      },
    } unless defined? Nipap::Default::CONNECTION_OPTIONS

    MIDDLEWARE = Faraday::RackBuilder.new do |builder|
      builder.use Faraday::Request::Retry
      # Convert file uploads to Faraday::UploadIO objects
      #builder.use Nipap::Request::MultipartWithFile
      # Checks for files in the payload
      #builder.use Faraday::Request::Multipart
      # Convert request params to JSON
      builder.use FaradayMiddleware::EncodeJson
      # Handle 4xx server responses
      builder.use Nipap::Response::RaiseError, Nipap::Error::ClientError
      # Parse JSON response bodies using MultiJson
      builder.use Nipap::Response::ParseJson
      # Handle 5xx server responses
      builder.use Nipap::Response::RaiseError, Nipap::Error::ServerError
      # Set Faraday's HTTP adapter
      builder.adapter Faraday.default_adapter
      #builder.use Faraday::Response::Logger     # log request & response to STDOUT
    end unless defined? Nipap::Default::MIDDLEWARE

    class << self

      # @return [Hash]
      def options
        Hash[Nipap::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # @return [String]
      def username
        ENV['NIPAP_USERNAME']
      end

      # @return [String]
      def password
        ENV['NIPAP_PASSWORD']
      end

      # @note This is configurable in case you want to use a different endpoint.
      # @return [String]
      def endpoint
        ENDPOINT
      end

      def connection_options
        CONNECTION_OPTIONS
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      # @return [Faraday::Builder]
      def middleware
        MIDDLEWARE
      end

      def logger
        LOGGER
      end
    end
  end
end
