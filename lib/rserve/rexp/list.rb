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
        t=super+(as_list.named? ? "named":"")
        if @payload.named?
          inner="{"+@payload.size.times.map {|i| "#{@payload.names[i]}=#{@payload.data[i].to_debug_string}"}.join(",")+"}"
        else
          inner="{"+@payload.size.times.map {|i| "#{@payload.data[i].to_debug_string}"}.join(",")+"}"
        end
        t+inner
      end
      def to_ruby_internal
        as_list.to_ruby
      end
    end
  end
end
