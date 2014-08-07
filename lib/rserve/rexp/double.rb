require 'rbconfig'
module Rserve
  class REXP
    class Double < REXP::Vector
      attr_reader :payload
      # NA is arch dependent
      
      case RbConfig::CONFIG['arch']
      
      when /i686-linux|mswin|mingw/
          NA = 269653970229425383598692395468593241088322026492507901905402939417320933254485890939796955099302180188971623023005661539310855695935759376615857567599472873400528811349204333736152257830107446553333670133666606746438802800063353690283455789426038632208916715592554825644961573453826957827246636338344317943808
        else
          NA = 0x100000000007a2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
      end
      
      NA_ARRAY=[162, 7, 0, 0, 0, 0, 240, 127]
      
      def initialize(data, attrs=nil)
        @payload=case data
          when Numeric
            [data.to_f]
          when Array
            data
          else
            raise ArgumentError, "Should be Numeric or Array"
        end
        super(attrs)
      end
      def length
        payload.length
      end
      def integer?
        true
      end
      def numeric?
        true
      end
      def as_integers
        @payload.map do |v|
          (na?(v) or Double.infinite?(v)) ? nil : v.to_i
        end
      end
      def as_doubles
        @payload.map do |v|
          na?(v) ? nil : v.to_f
        end
      end
      def as_strings
        @payload.map {|v| v.to_f.to_s}
      end

      def na?(value=:nil)
        #if value.nil?
        #  @payload.map {|v| v.respond_to? :nan and v.nan?}
        #else  
        #  value.respond_to? :nan? and value.nan?
        #end
        #p @payload
        return _na?(value) unless value==:nil
        @payload.map {|v| _na?(v) }
      end

      def self.infinite?(value)
        value.respond_to?(:infinite?) and !value.infinite?.nil?
      end


      def to_debug_string
        t=super
        t << "{"  << @payload.map(&:to_s).join(",") << "}"
      end
      def to_ruby_internal
        if dim 
          if dim.size==2
            as_matrix
          else
            as_nested_array
          end
        else
          super
        end
      end

protected

      def _na?(value)
        return true if value.nil?
        if value.is_a? Float
          return true if value.nan?
          return false if value.infinite?
        end
        value.to_i == NA
      end

    end
  end
end
