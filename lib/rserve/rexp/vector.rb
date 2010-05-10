module Rserve
  class REXP
    class Vector < REXP
      # returns the length of the vector (i.e. the number of elements)
      # @return length of the vector 
	public abstract int length();
    end
  end
end
