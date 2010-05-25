module Rserve
  class REXP
    # S4 REXP is a completely vanilla REXP
    class S4 < REXP
      def initialize(attr=nil)
        super(attr)
      end
    end
  end
end
