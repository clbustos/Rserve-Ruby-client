module Rserve
  class REXP
    class Double < REXP::Vector
      attr_reader :payload
      # In Java, you only need to add L at last :(
      NA = 0x100000000007a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
        @payload.map {|v| v.to_f.to_s}
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
