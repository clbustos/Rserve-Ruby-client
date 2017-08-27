module Rserve
  class REXP
    class Integer < REXP::Vector
      public_class_method :new
      attr_reader :payload
      NA = -2147483648
      def initialize(data, attrs=nil)
        @payload=case data
        when Integer
          [data]
        when Numeric
          [data.to_i]
        when Array
          data.map {|v| v.to_i}
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
        @payload
      end
      def as_doubles
        @payload.map {|v| na?(v) ? nil : v.to_f}
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
      def to_ruby_internal
        if dim
          if dim.size==2
            as_matrix
          else
            as_nested_array
          end
        else
          super
        end
      end
    end
  end
end
