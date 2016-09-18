module Nipap

  class Version
    MAJOR = 0 unless defined? Nipap::Version::MAJOR
    MINOR = 2 unless defined? Nipap::Version::MINOR
    PATCH = 4 unless defined? Nipap::Version::PATCH
    PRE = nil unless defined? Nipap::Version::PRE

    class << self

      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end

end
