module Rserve
  class REXP
    class Vector < REXP
      # returns the length of the vector (i.e. the number of elements)
      # @return length of the vector 
	def length;
        end;
        def vector?;
          true;
        end
        # returns a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values
        # @return a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values */
        def na?
        end
        def to_s
          super+"[#{length}]"
        end
        def to_debug_string
          super+"[#{length}]"
        end
    end
  end
end
