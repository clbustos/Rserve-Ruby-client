module Rserve
  class REXP
    class ExpressionVector < REXP::GenericVector
      def expression?
        true
      end
    end
  end
end
