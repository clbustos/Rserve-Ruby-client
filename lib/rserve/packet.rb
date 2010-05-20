module Rserve
  class Packet
    attr_reader :cont
    attr_reader :cmd
    def initialize(cmd, cont)
      raise "cont [#{cont.class} - #{cont.to_s}] should respond to :length" if !cont.nil? and !cont.respond_to? :length
      @cmd=cmd
      @cont=cont
    end
    def cont_len
      @cont.nil? ? 0 : @cont.length
    end
    def ok?
      @cmd&15==1
    end
    def error?
      @cmd&15==2
    end
    def stat
      (@cmd>>24)&127
    end
    def to_s
      "Packet[cmd=#{@cmd},len="+((cont.nil?)?"<nil>":(""+cont.length.to_s))+", con='"+(cont.nil?  ? "<nil>" : cont.pack("C*"))+"', status="+(ok? ? "ok":"error")+"]"
    end
  end
end
