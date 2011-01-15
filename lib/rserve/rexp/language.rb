module Rserve
  class REXP
    class Language < REXP::List
      def initialize(list, attr=nil)
        super(list,attr)
      end
      def language?
        true
      end
    end
  end
end
