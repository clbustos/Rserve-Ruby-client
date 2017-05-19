require 'rbconfig'
module Rserve
  class REXP
    class Complex < REXP::Vector
      attr_reader :payload

      def self.parse(da, attrs=nil)
        def self._na?(value)
          value.is_a?(Float) && value.nan?
        end

        r = da.each_slice(2).map do |r, i|
          if _na?(r) || _na?(i)
            next nil
          end
          ::Complex.rectangular(r.to_f, i.to_f)
        end
        self.new(r, attrs)
      end

      def initialize(data, attrs=nil)
        @payload=case data
          when ::Complex
            [data]
          when Array
            data
          else
            raise ArgumentError, "Should be Complex or Array - #{data.class}"
        end
        super(attrs)
      end

      def length
        payload.length
      end

      def integer?
        true
      end

      def numeric?
        true
      end

      def as_complex
        @payload
      end

      def as_doubles
        @payload.map(&:rect).flatten
      end

      def as_strings
        as_complex.map {|v| v.to_s}
      end

      # TODO: Not sure what the second line is good for
      def na?(value=nil)
        return _na?(value) unless value.nil?
        @payload.map {|v| _na?(v) }
      end

      def to_debug_string
        t=super
        t << "{"  << as_strings.join(", ") << "}"
      end

      # Retrieves values as Ruby array
      # NA will be replaced with nils
      def to_a
        @payload
      end

      def to_ruby_internal
        if @payload.nil? or @payload.size==0
          nil
        elsif @payload.size == 1
          as_complex[0]
        else
          as_complex
        end
      end


protected

      def _na?(value)
        if value.is_a? Float
          return true if value.nan?
          return false if value.infinite?
        end
        value.to_i == Double::NA
      end

    end
  end
end


