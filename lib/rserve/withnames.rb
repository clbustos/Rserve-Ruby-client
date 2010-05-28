module Rserve
  # Provides names to elements on an Array
  module WithNames
    attr_reader :names
    def names=(v)
      raise ArgumentError, "#size should be equal to object size" if !v.nil? and v.size!=self.size
      raise ArgumentError, "element must be String or nil" unless v.nil? or v.all? {|v1| v1.nil? or v1.is_a? String}
      @names=v
    end
    def push(v,name=nil)
      @names||=Array.new(self.size)
      (@names.size-self.size).times { @names.push(nil)}
      @names.push(name)
      super(v)
    end
    def inspect
      "#<#{self.class}:#{self.object_id} #{super} names:#{@names.inspect}>"
    end
    def clear
      @names=nil
      super()
    end
    def delete_at(i)
      unless @names.nil?
        @names.delete_at(i)
      end
      super(i)
    end
    def pop
      unless @names.nil?
        @names.pop
      end
      super
    end
 
    def reverse!
      unless @names.nil?
        @names.reverse!
      end
      super
    end
    def shift
      unless @names.nil?
        @names.shift
      end
      super  
    end
    def slice(*args)
      sliced=super(*args)
      unless @names.nil?
        sliced.extend Rserve::WithNames
        sliced.names=@names.slice(*args)
      end
      sliced
    end
    def named?
      !@names.nil?
    end
    def to_a
      Array.new(self)
    end
    def key_at(v)
      @names.nil? ?  nil : @names[v]
    end
    # Put a value on specific key
    # If key exists, replaces element of apropiate index
    # If key doesn't exists, works as push(value,key)
    def put(key,value)
      if key.nil?
        add(value)
        return nil
      end
      
      if !@names.nil?
        pos=@names.index(key)
        if !pos.nil?
          return @names[pos]=value
        end
      end      
      push(value,key)      
    end
    def __add(a,b=nil)
      if b.nil?
        @data.push(a)
        @names=Array.new(@data.size-1) if @names.nil?
        @names.push(nil)
      else
        @data.insert(a,b)
        @names.insert(a,nil)
      end
    end
    def [](v)
      case v
      when Integer
          at(v)
        when Array
          raise "You must use something like v[[1]]" if v.size!=1 or !v[0].is_a? Integer
          at(v[0]-1)
        when String
          if !@names.nil?
            i=@names.index(v)
            i.nil? ? nil : at(i)
          else
            nil
         end
      end
    end
  end
end
