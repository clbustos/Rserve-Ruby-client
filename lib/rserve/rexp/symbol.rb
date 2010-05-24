module Rserve
  class REXP
    class Symbol < REXP::Vector
      attr_reader :name
      def initialize(name)
        super()
        @name= (name.nil?) ? "" : name
      end
      def symbol?
        true
      end
      def as_string
        @name
      end
      def as_strings
        [@name]
      end
      def to_s
        super+"["+name+"]"
      end
      def to_debug_string
        super+"["+name+"]"
      end
      def to_ruby
        @name
      end
    end
  end
end
