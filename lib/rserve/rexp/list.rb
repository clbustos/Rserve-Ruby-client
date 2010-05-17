module Rserve
  class REXP
    class List < REXP::Vector
      attr_reader :payload
      def initialize(list, attrs=nil)
        @payload=list.nil? ? RList.new : list
        super(attrs)
      end
      def length
        payload.size
      end
      def list?
        true
      end
      def pair_list?
        true
      end
      def recursive?
        true
      end
      def as_list
        @payload
      end
      def to_s
        super+(as_list.named? ? "named":"")
      end
      def to_debug_string
        t=super
        t << "{"  << @payload.map {|k,v| "#{k}=#{v}"}.join(",\n") << "}"
      end
    end
  end
end
