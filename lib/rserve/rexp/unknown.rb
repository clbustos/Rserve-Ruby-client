module Rserve
  class REXP
    class Unknown < REXP
      attr_reader :type
      def initialize(type,attr=nil)
        @type=type
        super(attr)
      end
      def to_s
        super()+"[#{@type}]"
      end
    end
  end
end
