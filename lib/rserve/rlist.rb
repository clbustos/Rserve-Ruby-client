module Rserve
  class Rlist < Array
    include WithNames
    def initialize(data=nil, n=nil)
      @names=nil
      if data.nil?
        super()
      else        
        case data
        when Array
          super(data)
        when Numeric
          super([data])
        else
          raise ArgumentError
        end
      end
      if n
        @names=Array.new(size)
        n.each_index {|i| @names[i]=n[i]} if n.respond_to? :each_index
      end
    end
    def keys
      @names
    end
    # Returns the data without names, as Ruby objects
    def to_a
      self.map {|d| d.to_ruby} 
    end
    # Returns the data, as REXP
    def data
      self.map {|d| d}
    end
    def ==(o)
      #p "Comparing #{self.inspect} with #{o.inspect} gives #{o.is_a? Rlist and self.data==o.data and self.names==o.names}"
      o.is_a? Rlist and self.data==o.data and self.names==o.names
    end
    def to_s
      super+"[#{size}]"
    end
    
    # Returns an Array with module WithNames included
    # * Unnamed list: returns an Array
    # * Named List: returns a Hash. Every element without explicit name receive
    #   as key the number of element, 1-based
    #

    def to_ruby
      data=to_a
      data.extend WithNames
      data.names=@names
      data
    end
  end
end
