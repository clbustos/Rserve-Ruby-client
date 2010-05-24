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
      
      # Retrieves values as Ruby array
      # NA will be replaced with nils
      def to_a
        @payload.map {|v| na?(v) ? nil : v }
      end
      def to_ruby
        if @payload.size==0
          nil
        elsif @payload.size==1
          @payload[0]
        else
          @payload
        end
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
