module Rserve
  class REXP
    # represents a NULL object in R.
    # Note: there is a slight asymmetry - in R NULL is represented by a zero-length pairlist. For this reason <code>REXPNull</code> returns <code>true</code> for {@link #isList()} and {@link #asList()} will return an empty list. Nonetheless <code>REXPList</code> of the length 0 will NOT return <code>true</code> in {@link #isNull()} (currently), becasue it is considered a different object in Java. These nuances are still subject to change, because it's not clear how it should be treated. At any rate use <code>REXPNull</code> instead of empty <code>REXPList</code> if NULL is the intended value.
    class Null < REXP
      def null?
        true
      end
      def ==(v)
        v.is_a? self.class
      end
      def list?
        true
      end
      def as_list
        Rlist.new
      end
      def to_ruby
        nil
      end
    end
  end
end
