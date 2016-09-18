require 'faraday'
require 'nipap/error/bad_gateway'
require_relative '../error/bad_request'
require 'nipap/error/forbidden'
#require 'nipap/error/gateway_timeout'
require 'nipap/error/internal_server_error'
#require 'nipap/error/not_acceptable'
require 'nipap/error/not_found'
require 'nipap/error/service_unavailable'
#require 'nipap/error/too_many_requests'
require 'nipap/error/unauthorized'
#require 'nipap/error/unprocessable_entity'

module Nipap
  module Response
    class RaiseError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_class = @klass.errors[status_code]
        raise error_class.from_response(env) if error_class
      end

      def initialize(app, klass)
        @klass = klass
        super(app)
      end

    end
  end
end
