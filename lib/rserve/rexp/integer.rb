module Rserve
  class REXP
    class Integer < REXP::Vector
      public_class_method :new
      attr_reader :payload
      NA = -2147483648;
      def initialize(data, attrs=nil)
        @payload=case data
          when Numeric
            [data]
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
      def is_integer?
        true
      end
      def is_numeric?
        true
      end
      def as_integers
        @payload
      end
      def as_doubles
        @payload.map(&:to_f)
      end
      def as_strings
        @payload.map(&:to_s)
      end
      
      def is_na?(value=nil)
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
