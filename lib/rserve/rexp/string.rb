module Rserve
  class REXP
    class String < REXP::Vector
      attr_reader :payload
      NA="NA"
      def initialize(data, attrs=nil)
        @payload=case data
        when Array
          data.map {|v| v.to_s}
        else
          [data.to_s]
        end
        super(attrs)
      end
      def length
        payload.length
      end
      def string?
        true
      end
      def as_strings
        @payload
      end
      
      def na?(value=nil)
        if value.nil?
          @payload.map {|v| v==NA}
        else
          value==NA
        end
      end
      def to_debug_string
        t=super
        t << "{"  << @payload.map(&:to_s).join(",") << "}"
      end
      
    end
  end
end
