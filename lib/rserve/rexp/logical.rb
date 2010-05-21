module Rserve
  class REXP
    class Logical < REXP::Vector
      attr_reader :payload
      NA_internal = -2147483648;
      NA=-128
      TRUE=1
      FALSE=0
      def na?(value=nil)
        if value
          value==NA
        else
          @payload.map {|v| v==NA}
        end
      end
      def initialize(l,attr=nil)
        super(attr)
        if l.is_a? Array
          @payload=l.map {|l| l==1 ? TRUE : FALSE}
        else
          @payload = [ l==1 ? TRUE : FALSE ]
        end
      end
      def length
        @payload.length
      end
      def logical?
        true
      end
      def as_integers
        @payload.map {|v| v==NA ? REXP::Integer::NA : ( v == FALSE ? 0 : 1 )} 
      end
      def as_doubles
        @payload.map {|v| v==NA ? REXP::Double::NA : ( v == FALSE ? 0.0 : 1.0 )} 
      end
      def as_strings
        @payload.map {|v| v==NA ? REXP::Double::NA : ( v == FALSE ? "FALSE" : "TRUE" )} 
      end
      def true?
        @payload.map {|v| v==TRUE}
      end
      def false?
        @payload.map {|v| v==FALSE}
        
      end
    end
  end
end
