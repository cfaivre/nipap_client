require_relative '../error'

module Nipap
  class Error
    # Raised when Nipap returns a 4xx HTTP status code or there's an error in Faraday
    class ClientError < Nipap::Error

      # Create a new error from an HTTP environment
      #
      # @param response [Hash]
      # @return [Nipap::Error]
      def self.from_response(response={})
        new(parse_error(response[:body]), response[:response_headers])
      end

    private

      def self.parse_error(body)
        if body.nil?
          ''
        elsif body[:error]
          body[:error]
        elsif body[:errors]
          # generally in this format
          # {"errors"=>{"package"=>["can't be blank"], "domain_name"=>["can't be blank"]}}
          if RUBY_VERSION =~ /1\.8/
            sorted = Array(body[:errors]).sort_by {|sym| sym.to_s}
          else
            sorted = Array(body[:errors]).sort
          end
          first = sorted.first

          if first.is_a?(Array)
            first[0].to_s + " " + first[1][0].to_s.chomp
          else
            first.chomp
          end
        end
      end

    end
  end
end
