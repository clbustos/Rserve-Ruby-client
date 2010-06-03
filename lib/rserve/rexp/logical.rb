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
      # l should be a value or array of 0 and 1.
      def initialize(l,attr=nil)
        super(attr)
        if l.is_a? Array
          @payload= l
        else
          @payload = [ l==NA ? NA : (l==1 ? TRUE : FALSE) ]
        end
      end
      def length
        @payload.length
      end
      def logical?
        true
      end
      def as_bytes
        @payload
      end

      # Retrieves values as Ruby array of true and false values
      # NA will be replaced with nils
      def to_a
        @payload.map {|v|
          case v
          when NA then nil
          when TRUE then true
          when FALSE then false
          end
        }
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
      
      def to_ruby_internal
        if @payload.nil? or @payload.size==0
          nil
        elsif @payload.size==1
          @payload[0]==1 ? true : false
        else
          @payload.map {|v| na?(v) ? nil : (v==1 ? true : false)}
        end
      end
      
    end
  end
end
