module Rserve
  class Packet
    attr_reader :cont
    attr_reader :cmd

    ERROR_DESCRIPTIONS={
      2=>'Invalid expression',
      3=>'Parse error',
     65=>'Login error',
    127=>'Unknown variable/method'}

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
    def get_error_description(stat)
      ERROR_DESCRIPTIONS[stat]
    end
    def to_s
      if error?
        status="error:'#{get_error_description(stat)}'(#{stat})"
      else
        status="ok"
      end
      "Packet[cmd=#{@cmd},len="+((cont.nil?)?"<nil>":(""+cont.length.to_s))+", con='"+(cont.nil?  ? "<nil>" : cont.pack("C*"))+"', status=#{status}]"
    end
  end
end
