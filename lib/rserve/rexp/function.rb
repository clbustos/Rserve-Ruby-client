module Rserve
  class REXP
    # represents a Function in R
    class Function < REXP
      attr_accessor :head, :body
      def initialize(head,body)
        super()
        @head=head
        @body=body
      end
      def to_ruby
        {:head=>@head.to_ruby,:body=>@body.to_ruby}
      end
    end
  end
end
