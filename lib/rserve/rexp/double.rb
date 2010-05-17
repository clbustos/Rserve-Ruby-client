module Rserve
  class REXP
    class Double < REXP::Vector
      attr_reader :payload
      NA = 0x7ff00000000007a2;
      def initialize(data, attrs=nil)
        @payload=case data
          when Numeric
            [data.to_f]
          when Array
            data
          else
            raise ArgumentError, "Should be Numeric or Array"
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
      def as_integers
        @payload.map(&:to_i)
      end
      def as_doubles
        @payload
      end
      def as_strings
        @payload.map(&:to_s)
      end
      
      def na?(value=nil)
        return value == NA unless value.nil?
        @payload.map {|v| v==NA}
      end
      def to_debug_string
        t=super
        t << "{"  << @payload.map(&:to_s).join(",") << "}"
      end
    end
  end
end
