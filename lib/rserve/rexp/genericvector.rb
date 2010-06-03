module Rserve
  class REXP
    class GenericVector < REXP::Vector
      attr_reader :payload
      def initialize(list, attr=nil)
        super(attr)
        @payload=list.nil? ? Rlist.new() : list
        if (attr.nil? and payload.named? )
          @attr = REXP::List.new(
          Rlist.new([REXP::String.new(payload.keys())],
          ["names"]));
        end
      end
      def length
        @payload.size
      end
      def list?
        true
      end
      def recursive?
        true
      end
      def as_list
        @payload
      end
      def to_ruby_internal
        @payload.to_ruby
      end
    end
  end
end
