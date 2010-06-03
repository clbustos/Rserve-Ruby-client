module Rserve
  class REXP
    class Vector < REXP
      attr_reader :payload
      def ==(o)
        #p "Comparing #{self.inspect} with #{o.inspect} gives #{self.payload==o.payload and self.attr==o.attr}"
        self.class==o.class and self.payload==o.payload and self.attr==o.attr
      end

      # returns the length of the vector (i.e. the number of elements)
      # @return length of the vector
      def length
      end
      def vector?
        true
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
      def to_ruby_internal
        if @payload.nil? or @payload.size==0
          nil
        elsif @payload.size==1
          @payload[0]
        else
          @payload.map {|v| na?(v) ? nil : v}
        end
      end
    end
  end
end
