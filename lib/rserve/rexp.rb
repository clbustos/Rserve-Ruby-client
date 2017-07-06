module Rserve
  # Basic class representing an object of any type in R. Each type in R in represented by a specific subclass. 
  # This class defines basic accessor methods (<tt>as</tt>_<i>xxx</i>), type check methods (<i>XXX</i><tt>?</tt>), gives access to attributes (REXP.get_attribute, REXP.has_attribute?) as well as several convenience methods. If a given method is not applicable to a particular type, it will throw the MismatchError exception.
  # 
  # This root class will throw on any accessor call and returns <code>false</code> for all type methods. This allows subclasses to override accessor and type methods selectively.
  #
  class REXP
    MismatchError= Class.new(StandardError)
    attr_reader :attr
    def initialize(attr=nil)
      # Sorry for this, but I think is necessary to maintain sanity of attributes
      raise ArgumentError, "Attribute should be a REXP::List, #{attr.class} provided" unless attr.nil? or attr.is_a? REXP::List
      @attr=attr
    end
    # specifies how many items of a vector or list will be displayed in {@link #toDebugString}
    MaxDebugItems = 32
    # :section: type checks
    
    # check whether the <code>REXP</code> object is a character vector (string).
    #
    # @return [boolean] <code>true</code> if the receiver is a character vector, <code>false</code> otherwise
    def string?
      false
    end

    # check whether the <code>REXP</code> object is a numeric vector.
    #
    # @return [boolean] <code>true</code> if the receiver is a numeric vector, <code>false</code> otherwise

    def numeric?
      false
    end
    # check whether the <code>REXP</code> object is an integer vector.
    # 
    # @return [boolean] <code>true</code> if the receiver is an integer vector, <code>false</code> otherwise
    def integer?
      false
    end
    # check whether the <code>REXP</code> object is NULL.
    # 
    # @return [boolean] <code>true</code> if the receiver is NULL, <code>false</code> otherwise
    def null?
      false
    end
    
    # check whether the <code>REXP</code> object is a factor.
    #
    # @return [boolean] <code>true</code> if the receiver is a factor, <code>false</code> otherwise
    def factor?
      false
    end
    
    # check whether the <code>REXP</code> object is a list (either generic vector or a pairlist - i.e. REXP.asList() will succeed).
    #
    # @return [boolean] <code>true</code> if the receiver is a generic vector or a pair-list, <code>false</code> otherwise
    def list?
      false
    end
    # check whether the <code>REXP</code> object is a pair-list.
    #
    # @return [boolean] <code>true</code> if the receiver is a pair-list, <code>false</code> otherwise
    def pair_list?
      false
    end
    # check whether the <code>REXP</code> object is a logical vector.
    #
    # @return [boolean] <code>true</code> if the receiver is a logical vector, <code>false</code> otherwise */
    def logical?
      false
    end
    # check whether the <code>REXP</code> object is an environment.
    # 
    # @return [boolean] <code>true</code> if the receiver is an environment, <code>false</code> otherwise
    def environment?
      false
    end
    # check whether the <code>REXP</code> object is a language object.
    # 
    # @return [boolean] <code>true</code> if the receiver is a language object, <code>false</code> otherwise
    def language?
      false
    end
    # check whether the <code>REXP</code> object is an expression vector.
    # 
    # @return [boolean] <code>true</code> if the receiver is an expression vector, <code>false</code> otherwise
    def expression?
      false
    end
    # check whether the <code>REXP</code> object is a symbol.
    # 
    # @return [boolean] <code>true</code> if the receiver is a symbol, <code>false</code> otherwise
    def symbol?
      false
    end
    # check whether the <code>REXP</code> object is a vector.
    #
    # @return [boolean] <code>true</code> if the receiver is a vector, <code>false</code> otherwise
    def vector?
      false
    end
    # check whether the <code>REXP</code> object is a raw vector
    # @return [boolean]  <code>true</code> if the receiver is a raw vector, <code>false</code> otherwise
    def raw?
      false
    end
    # check whether the <code>REXP</code> object is a complex vector
    # @return [boolean] <code>true</code> if the receiver is a complex vector, <code>false</code> otherwise
    def complex?
      false
    end
    # check whether the <code>REXP</code> object is a recursive obejct
    # @return [boolean] <code>true</code> if the receiver is a recursive object, <code>false</code> otherwise
    def recursive?
      false
    end
    # check whether the <code>REXP</code> object is a reference to an R object
    # @return [boolean] <code>true</code> if the receiver is a reference, <code>false</code> otherwise
    def reference?
      false
    end
    
    # :section: basic accessor methods
    
    # returns the contents as an array of Strings (if supported by the represented object).
    # 
    # @return [Array] 
    def as_strings
      raise MismatchError, "String"
    end
    # returns the contents as an array of integers (if supported by the represented object)
    # 
    # @return [Array] 
    
    def as_integers
      raise MismatchError, "int"
    end

    # returns the contents as an array of floats (C double precision) (if supported by the represented object).
    # 
    # @return [Array] 

    def as_doubles
       raise MismatchError,"double"
    end

    # On Ruby, Float are stored in double precision.
    #
    # @return [Array]
    def as_floats
      as_doubles
    end
    
    # returns the contents as an array of bytes (if supported by the represented object).
    # 
    # @return [Array]
    
    def as_bytes
      raise MismatchError , "byte"
    end
    # returns the contents as a (named) list (if supported by the represented object)
    # 
    # @return [Array]
    def as_list
      raise MismatchError,"list"
    end
    # returns the contents as a factor (if supported by the represented object).
    #
    # @return [RFactor]
    def as_factor
      raise MismatchError,"factor"
    end
    
    # returns the length of a vector object. Note that we use R semantics here, i.e. a matrix will have a length of <i>m * n</i> since it is represented by a single vector (see REXP.dim) for retrieving matrix and multidimentional-array dimensions).
    # 
    # @return [Integer] length (number of elements) in a vector object.
    def length
      raise MismatchError, "vector"
    end
    
    # returns a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values.
    # 
    # @return [boolean] a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values.
    # 
    def na?
      raise MismatchError, "vector"
    end
    
    # :section: convenience accessor methods
    
    
    # convenience method corresponding to <code>as_integer()[0]</code>
    # 
    # @return [Integer] first entry returned by as_integers()
    def as_integer
      as_integers[0]
    end
    # Alias for as_integer().
    #
    # @return [Integer]
    
    def to_i
      as_integers[0]
    end
    # convenience method corresponding to <code>as_floats[0]</code>.
    # 
    # @return [Float] first entry returned by as_doubles()
    def as_double
      as_doubles[0]
    end
    # Alias for as_double()
    # 
    # @return [Float]
    def as_float
      as_double
    end
    # Alias for as_float()
    # 
    # @return [Float]
    def to_f
      as_double
    end
    # convenience method corresponding to <code>as_strings[0]</code>.
    # 
    # @return [String] first entry returned by REXP.as_strings
    def as_string
      as_strings[0]
    end
    
    # :section: methods common to all REXPs
    
    # Retrieve an attribute of the given name from this object.
    #
    # @param [String] attribute name.
    # @return [Rlist, nil] attribute value or <code>nil</code> if the attribute does not exist
    
    def get_attribute(name)
      has_attribute?(name)  ? @attr.as_list[name] : nil
    end
    
    # checks whether this object has a given attribute.
    # 
    # @param [String] attribute name.
    # @return [boolean] <code>true</code> if the attribute exists, <code>false</code> otherwise
    def has_attribute? (name)
      !@attr.nil? and @attr.list? and !@attr.as_list[name].nil?
    end
    
    
    # :section: helper methods common to all REXPs
    
    # Returns dimensions of the object (as determined by the REXP::dim() attribute).
    # 
    #  @return [Array] an array of integers with corresponding dimensions or <code>nil</code> if the object has no dimension attribute
    def dim
      begin
        return has_attribute?("dim") ? @attr.as_list['dim'].as_integers :  nil;
        rescue MismatchError
      # nothing to do
      end
      nil
    end
    
    # determines whether this object inherits from a given class in the same fashion as the <code>inherits()</code> function in R does (i.e. ignoring S4 inheritance).
    #
    # @param [String] klass class name.
    # @return [boolean] <code>true</code> if this object is of the class <code>klass</code>, <code>false</code> otherwise.
    def inherits?(klass)
      return false if (!has_attribute? "class")
      begin
        c = get_attribute("class").as_strings;
        if (!c.nil?)
          return c.any? {|v| v.equals klass}
        end
      rescue MismatchError
      end
      false
    end
    

    
    # returns representation that it useful for debugging (e.g. it includes attributes and may include vector values)
    #
    # @return [String] extended description of the obejct -- it may include vector values
    def to_debug_string
      (!@attr.nil?) ? (("<"+@attr.to_debug_string()+">")+to_s()) : to_s
    end
    
    
    #  :section: complex convenience methods
    
    
    # returns the content of the REXP as a ruby matrix of doubles (2D-array: m[rows][cols]). You could use Matrix.rows(result) to create
    # a ruby matrix.
    # Matrix(c.eval("matrix(c(1,2,3,4,5,6),2,3)").as_double_matrix());</code>
    #
    # @return [Array] 2D array of doubles in the form double[rows][cols] or <code>nil</code> if the contents is no 2-dimensional matrix of doubles
    def as_double_matrix
      ct = as_doubles()
      dim = get_attribute "dim"
      raise MismatchError, "matrix (dim attribute missing)" if dim.nil?
      ds = dim.as_integers
      raise MismatchError, "matrix (wrong dimensionality)"     if (ds.length!=2)
      as_nested_array
      
      #m,n = ds[0], ds[1]
      # R stores matrices as matrix(c(1,2,3,4),2,2) = col1:(1,2), col2:(3,4)
      # we need to copy everything, since we create 2d array from 1d array
      #r=m.times.map {|i| n.times.map {|j| ct[j*n+i]}}
    end
    # Returns a standard library's matrix.
    #
    # @return [Matrix]
    def as_matrix
      require 'matrix'
      Matrix.rows(as_double_matrix)
    end
    # Returns the content of the REXP as a serie of nested arrays of X dimensions
    #
    # @return [Array]
    def as_nested_array
      ct=as_doubles
      dim = get_attribute "dim"
      raise MismatchError, "array (dim attribute missing" if dim.nil?
      ds = dim.as_integers.reverse
      split_array(ct,ds)
    end
    
    def split_array(ar, dims) # :nodoc:
      #puts "#{ar} - #{dims}"
      if dims.size==1
        raise "Improper size ar:#{ar} , dims=#{dims[0]}" if ar.size!=dims[0]
        return ar 
      elsif dims.size==2
        return Array.new() if dims.any? {|v| v==0}
        dims.reverse!
        # should rearrange values as R do
        # dims[0]=cols, dims[1]=rows
        if(true)
        out=[]
        ar.each_with_index {|v,i| 
          r=(i/dims[0]).to_i;
          c=i%dims[0];
          #p "#{r} : #{c}";
          out[c*dims[1]+r]=v
        }
        #p out
        
        raise "out size should equal to ar size" if ar.size!=out.size
        ar=out
        end
      end
      dims_c=dims.dup
      current_dim=dims_c.shift
      current_size=ar.size/current_dim
      #puts "dims: #{dims_c} cs:#{current_size}, cd:#{current_dim}"
      parts=current_dim.times.map do |i|
        split_array(ar[i*current_size, current_size], dims_c)
      end
      parts
    end
    
    # :section: tools
    
    # creates a data frame object from a list object using integer row names.
    #
    # *  @param [Rlist] a (named) list of vectors (REXP::Vector subclasses), each element corresponds to a column and all elements must have the same length.
    # *  @return [GenericVector] a data frame object representation.
    def self.create_data_frame(l)
      raise(MismatchError, "data frame (must have dim>0)") if l.nil? or l.size<1
      raise MismatchError, "data frame (contents must be vectors)" if (!(l[0].is_a? REXP::Vector))
      fe = l[0]
      return REXP::GenericVector.new(l,
      REXP::List.new(
      Rlist.new(
      [
      REXP::String.new("data.frame"),
      REXP::String.new(l.keys()),
      REXP::Integer.new([REXP::Integer::NA, -fe.length()])
      ],
      ["class", "names", "row.names" ])
      )
      )
    end
    # Retrieves the best Ruby representation of data
    #
    # If R object has attributes, the Ruby object is extended with Rserve::WithAttributes.
    # If R object have names, the Ruby object is extended with Rserve::WithNames and their elements can be accessed with [] using numbers and literals.
    #  
    # @return [Object] Ruby object.
    def to_ruby
      v=to_ruby_internal
      if !v.nil? and !v.is_a? Numeric and !v.is_a? TrueClass and !v.is_a? FalseClass
        v.extend Rserve::WithAttributes
        v.attributes=attr.to_ruby unless attr.nil?
        if !v.attributes.nil? and v.attributes.has_name? 'names'
          v.attributes['names']=[v.attributes['names']] unless v.attributes['names'].is_a? Array or v.attributes['names'].nil?
          v.extend Rserve::WithNames
          v.names=v.attributes['names']
        end
        if v.attributes and v.attributes.has_name? 'dim' and v.attributes.has_name? 'dimnames' and v.attributes['dim'].size == 2
          if v.is_a? Array
            v.extend Rserve::With2DSizes
            v.sizes = v.attributes['dim']
          end
          v.extend Rserve::With2DNames
          v.names = v.attributes['dimnames'].map{|dimension_names| (dimension_names.nil? or dimension_names.is_a?(Array)) ? dimension_names : [dimension_names]}
        end
      end
      
      # Hack: change attribute row.names according to spec 
      if !attr.nil? and attr.as_list.has_name? 'class' and attr.as_list['class'].as_string=='data.frame' and (attr.as_list['row.names'].is_a?(REXP::Integer)) and attr.as_list['row.names'].as_integers[0]==REXP::Integer::NA
        v.attributes['row.names']=(1..(-attr.as_list['row.names'].as_integers[1])).to_a
      end
      
      v
    end
    # Return the bare-bone representation of REXP as a Ruby Object. 
    # Called by REXP.to_ruby, so shouldn't be used directly by developers.
    # 
    def to_ruby_internal
      raise "You should implement to_ruby_internal for #{self.class}"
    end
  end
end
    
    
require_relative 'rexp/environment'
require_relative 'rexp/null'
require_relative 'rexp/unknown'


require_relative 'rexp/vector'

require_relative 'rexp/raw'
require_relative 'rexp/symbol'
require_relative 'rexp/string'
require_relative 'rexp/double'
require_relative 'rexp/integer'
require_relative 'rexp/logical'

require_relative 'rexp/factor'

require_relative 'rexp/genericvector'
require_relative 'rexp/expressionvector'


require_relative 'rexp/list'
require_relative 'rexp/language'
require_relative 'rexp/s4'

require_relative 'rexp/reference'

require_relative 'rexp/wrapper'
require_relative 'rexp/function'

