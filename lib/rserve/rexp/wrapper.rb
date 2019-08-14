module Rserve
  class REXP
    #
    #  Utility module to wrap an Ruby Object into a REXP object.
    #
    # This facilitates wrapping native ruby objects and arrays
    # into REXP objects that can be pushed to R
    #
    # @author Romain Francois <francoisromain@free.fr>
    #
    module Wrapper
      def self.wrap(o)
        return o if o.is_a? REXP
        return o.to_REXP if o.respond_to? :to_REXP
        case o
          when TrueClass
            REXP::Logical.new(1)
          when FalseClass
            REXP::Logical.new(0)
          when NilClass
            REXP::Null.new()
          when ::String
            REXP::String.new(o)
          when Integer
            REXP::Integer.new(o)
          when Float
            REXP::Double.new(o)
          when Array
            find_type_of_array(o)
          when ::Matrix
            create_matrix(o)
          else
            nil
        end
      end
      def self.create_matrix(o)
        data= o.column_size.times.map {|j|
          o.column(j).to_a
        }.flatten
        attr=REXP::List.new(
          Rlist.new(
            [
            REXP::String.new("matrix"),
            REXP::Integer.new([o.row_size, o.column_size])
            ],
            ["class", "dim" ]
            )
          )
        REXP::Double.new(data, attr)
      end
      def self.find_type_of_array(o)
        if o.all? {|v| v.nil?}
          REXP::Integer.new([REXP::Integer::NA]*o.size)
        elsif o.all? {|v| v.is_a? Integer or v.nil?}
          REXP::Integer.new(o.map {|v| v.nil? ? REXP::Integer::NA : v})
        elsif o.all? {|v| v.is_a? Numeric or v.nil?}
          REXP::Double.new(o.map {|v| v.nil? ? REXP::Double::NA : v.to_f})
        elsif o.all? {|v| v.is_a? ::String or v.nil?}
          REXP::String.new(o.map {|v| v.nil? ? REXP::String::NA : v})
        elsif o.all? {|v| v.is_a? TrueClass or v.is_a? FalseClass or v.nil?}
          REXP::Logical.new(o.map{|v| v.nil? ? REXP::Logical::NA : (v ? 1 : 0)})
          # mixed values. We must return a LIST!
        else
          REXP::GenericVector.new(
          Rlist.new(
          o.map{|v| wrap(v)}
          )
          )
        end
      end
    end
  end
end
