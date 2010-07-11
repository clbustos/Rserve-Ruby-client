module Rserve
  class REXP
    class Factor < REXP::Integer
      attr_reader :levels
      def initialize(ids,levels,attr=nil)
        super(ids,attr)
        @levels = (levels.nil?)? Array.new : levels;
        @factor = RFactor.new(@payload, @levels, false, 1)
      end
      def factor?
        true
      end
      def as_factor
        @factor
      end
      def as_strings
        @factor.as_strings
      end
      def to_s
        super+"[#{levels.length}]"
      end
      def to_ruby_internal
        as_strings
      end
    end
  end
end
