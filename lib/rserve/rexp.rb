module Rserve
  #  Basic class representing an object of any type in R. Each type in R in represented by a specific subclass.
  # 
  # This class defines basic accessor methods (<tt>as</tt><i>XXX</i>), type check methods (<tt>is</tt><i>XXX</i>), gives access to attributes ({@link #getAttribute}, {@link #hasAttribute}) as well as several convenience methods. If a given method is not applicable to a particular type, it will throw the {@link MismatchException} exception.
  #
  # This root class will throw on any accessor call and returns <code>false</code> for all type methods. This allows subclasses to override accessor and type methods selectively.
  # 
  class REXP
    MismatchException= Class.new(Exception)
    attr_reader :attr
    def initialize(attr=nil)
      # Sorry for this, but I think is necessary to maintain sanity of attributes
      raise ArgumentError, "Attribute should be a REXP::List, #{attr.class} provided" unless attr.nil? or attr.is_a? REXP::List
      @attr=attr
    end
    # specifies how many items of a vector or list will be displayed in {@link #toDebugString} 
    MaxDebugItems = 32
    # :section: type checks
    # check whether the <code>REXP</code> object is a character vector (string)
    # @return <code>true</code> if the receiver is a character vector, <code>false</code> otherwise 
	
    def string?;return false;end

    # # check whether the <code>REXP</code> object is a numeric vector
    # @return <code>true</code> if the receiver is a numeric vector, <code>false</code> otherwise 

    def numeric?;false;end
    # check whether the <code>REXP</code> object is an integer vector
    # @return <code>true</code> if the receiver is an integer vector, <code>false</code> otherwise 
    def integer?;false;end
    # check whether the <code>REXP</code> object is NULL
    # @return <code>true</code> if the receiver is NULL, <code>false</code> otherwise 
    def null?;false;end
    # check whether the <code>REXP</code> object is a factor
    # @return <code>true</code> if the receiver is a factor, <code>false</code> otherwise 
    def factor?;false;end
    # check whether the <code>REXP</code> object is a list (either generic vector or a pairlist - i.e. {@link #asList()} will succeed)
    # @return <code>true</code> if the receiver is a generic vector or a pair-list, <code>false</code> otherwise 
    def list?;false;end
    # check whether the <code>REXP</code> object is a pair-list
    # @return <code>true</code> if the receiver is a pair-list, <code>false</code> otherwise 
    def pair_list?;false;end
    # check whether the <code>REXP</code> object is a logical vector
    # @return <code>true</code> if the receiver is a logical vector, <code>false</code> otherwise */
    def logical?;false;end
    #  check whether the <code>REXP</code> object is an environment
    # @return <code>true</code> if the receiver is an environment, <code>false</code> otherwise 
    def environment?;false;end
    # check whether the <code>REXP</code> object is a language object
    # @return <code>true</code> if the receiver is a language object, <code>false</code> otherwise 
    def language?;false;end
    # check whether the <code>REXP</code> object is an expression vector
    # @return <code>true</code> if the receiver is an expression vector, <code>false</code> otherwise 
    def expression?;false;end
    # check whether the <code>REXP</code> object is a symbol
    # @return <code>true</code> if the receiver is a symbol, <code>false</code> otherwise
    def symbol?;false;end
    # check whether the <code>REXP</code> object is a vector
    # @return <code>true</code> if the receiver is a vector, <code>false</code> otherwise 
    def vector?;false;end
    # check whether the <code>REXP</code> object is a raw vector
    # @return <code>true</code> if the receiver is a raw vector, <code>false</code> otherwise 
    def raw?;false;end
    # check whether the <code>REXP</code> object is a complex vector
    # @return <code>true</code> if the receiver is a complex vector, <code>false</code> otherwise 
    def complex?;false;end
    # check whether the <code>REXP</code> object is a recursive obejct
    # @return <code>true</code> if the receiver is a recursive object, <code>false</code> otherwise 
    def recursive?;false;end
    # check whether the <code>REXP</code> object is a reference to an R object
    # @return <code>true</code> if the receiver is a reference, <code>false</code> otherwise 
    def reference?;false;end

        # :section: basic accessor methods
	# returns the contents as an array of Strings (if supported by the represented object) 
        def as_strings;raise MismatchException, "String";end
	# returns the contents as an array of integers (if supported by the represented object) 
  
	def as_integers; raise MismatchException, "int";end;
	# returns the contents as an array of doubles (if supported by the represented object) 
	def as_doubles; raise MismatchException,"double";end;
  
  # On Ruby, Float are stored in double precision 
  alias :as_floats :as_doubles 
    
	# returns the contents as an array of bytes (if supported by the represented object)
	def as_bytes; raise MismatchException , "byte";end;
	# returns the contents as a (named) list (if supported by the represented object)
	def as_list; raise MismatchException,"list";end;
	# returns the contents as a factor (if supported by the represented object) 
	def as_factor; raise MismatchException,"factor";end;

	# returns the length of a vector object. Note that we use R semantics here, i.e. a matrix will have a length of <i>m * n</i> since it is represented by a single vector (see {@link #dim} for retrieving matrix and multidimentional-array dimensions).
	# * @return length (number of elements) in a vector object
	# * @throws MismatchException if this is not a vector object 
	def length()
    raise MismatchException, "vector";
  end

	# returns a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values
	# *  @return a boolean vector of the same length as this vector with <code>true</code> for NA values and <code>false</code> for any other values
	# * @throws MismatchException if this is not a vector object 
	def na?
    raise MismatchException, "vector"
  end
	
	# :section: convenience accessor methods
	# convenience method corresponding to <code>as_integer()[0]</code>
	# @return first entry returned by {@link #as_integer} 
	def as_integer
    as_integers[0]
  end 
	# convenience method corresponding to <code>asDoubles()[0]</code>
	# @return first entry returned by {@link #asDoubles} 
  def as_double
    as_doubles[0]
  end
  
  alias  :as_float :as_double
	# convenience method corresponding to <code>asStrings()[0]</code>
	# @return first entry returned by {@link #asStrings} 
  def as_string
    as_strings[0]
  end
	# // methods common to all REXPs
	
	# retrieve an attribute of the given name from this object
  # * @param name attribute name
	# * @return attribute value or <code>null</code> if the attribute does not exist 
  
  def get_attribute(name)
    nil if @attr.nil? or !@attr.list?
    @attr.as_list[name]
  end
	
  # checks whether this obejct has a given attribute
  # * @param name attribute name
  # * @return <code>true</code> if the attribute exists, <code>false</code> otherwise 
  def has_attribute? (name) 
    return (!@attr.nil? and @attr.list? and !@attr.as_list[name].nil?);
  end


  # :section: helper methods common to all REXPs

  # returns dimensions of the object (as determined by the "<code>dim</code>" attribute)
  #  @return an array of integers with corresponding dimensions or <code>null</code> if the object has no dimension attribute 
  def dim
    begin
      return has_attribute?("dim") ? @attr.as_list['dim'].as_integers :  nil;
    rescue MismatchException
      # nothing to do
    end
     nil
  end
	
	# determines whether this object inherits from a given class in the same fashion as the <code>inherits()</code> function in R does (i.e. ignoring S4 inheritance)
	# @param klass class name
	# @return <code>true</code> if this object is of the class <code>klass</code>, <code>false</code> otherwise 
	def inherits?(klass) 
    return false if (!has_attribute? "class")
    begin
			c = get_attribute("class").as_strings;
			if (!c.nil?)
        return c.any? {|v| v.equals klass}
      end
    rescue MismatchException
    end
		return false;
  end


	
    # returns a string description of the object
    # @return string describing the object - it can be of an arbitrary form and used only for debugging (do not confuse with {@link #asString()} for accessing string REXPs) 
    def to_s
    return (!@attr.nil?) ? "+" : ""
    end

    # returns representation that it useful for debugging (e.g. it includes attributes and may include vector values -- see {@link #maxDebugItems})
    # @return extended description of the obejct -- it may include vector values
    def to_debug_string 
      (!@attr.nil?) ? (("<"+@attr.to_debug_string()+">")+to_s()) : to_s
    end
        
    
    #//======= complex convenience methods
    # returns the content of the REXP as a ruby matrix of doubles (2D-array: m[rows][cols]). You could use Matrix.rows(result) to create
    # a ruby matrix.
    # Matrix(c.eval("matrix(c(1,2,3,4,5,6),2,3)").as_double_matrix());</code>
    #
    # @return 2D array of doubles in the form double[rows][cols] or <code>null</code> if the contents is no 2-dimensional matrix of doubles 
    def as_double_matrix()  
      ct = as_doubles()
      dim = get_attribute "dim"
      raise MismatchException, "matrix (dim attribute missing)" if dim.nil?
      ds = dim.as_integers
      raise MismatchException, "matrix (wrong dimensionality)"     if (ds.length!=2)
      m,n = ds[0], ds[1]
      # R stores matrices as matrix(c(1,2,3,4),2,2) = col1:(1,2), col2:(3,4)
      # we need to copy everything, since we create 2d array from 1d array
      r=m.times.map {|i| n.times.map {|j| ct[j*n+i]}}
    end
    # Returns a standard library's matrix
    def as_matrix
      require 'matrix'
      Matrix.rows(as_double_matrix)
    end
    
    # :section: tools

    # creates a data frame object from a list object using integer row names
    # *  @param l a (named) list of vectors ({@link REXPVector} subclasses), each element corresponds to a column and all elements must have the same length
    # *  @return a data frame object
    #  *  @throws MismatchException if the list is empty or any of the elements is not a vector 
    def create_data_frame(l)
      raise(MismatchException, "data frame (must have dim>0)") if l.nil? or l.size<1
      raise MismatchException, "data frame (contents must be vectors)" if (!(l[0].is_a? REXP::Vector))
      fe = l[0]
      return REXP::GenericVector.new(l,
      REXP::List.new(
      RList.new(
              [
              REXP::String.new("data.frame"),
              REXP::String.new(l.keys()),
              REXP::Integer.new([REXP::Integer.NA, -fe.length()])
              ],
              ["class", "names", "row.names" ])
      )
      )
    end
    # Retrieves the best Ruby representation of data
    def to_ruby
      raise "You should implement this!"
    end
  end
end


require 'rserve/rexp/environment'
require 'rserve/rexp/null'
require 'rserve/rexp/unknown'

require 'rserve/rexp/vector'

require 'rserve/rexp/symbol'
require 'rserve/rexp/string'
require 'rserve/rexp/double'
require 'rserve/rexp/integer'
require 'rserve/rexp/logical'

require 'rserve/rexp/factor'

require 'rserve/rexp/genericvector'
require 'rserve/rexp/expressionvector'


require 'rserve/rexp/list'
require 'rserve/rexp/language'

require 'rserve/rexp/reference'

require 'rserve/rexp/wrapper'

