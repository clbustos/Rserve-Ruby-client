module Rserve
  class REXP
    class Raw < REXP::Vector
      def initialize(l,attr=nil)
        super(attr);
        @payload=(l.nil?) ? Array.new() : l;
      end
      def length
        @payload.length
      end
      def raw?
        true
      end
      def as_bytes
        @payload
      end
    end
  end
end
