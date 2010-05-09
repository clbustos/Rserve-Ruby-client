module Rserve
  class Packet
    attr_reader :cont
    attr_reader :cmd
    def initialize(cmd,cont)
      raise "Cont should respond to :length" unless cont.respond_to? :length
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
      "Packet[cmd=#{@cmd},len="+((cont.nil?)?"<null>":(""+cont.length.to_s))+",con='"+cont.pack("C*")+"']"
    end
  end
end
