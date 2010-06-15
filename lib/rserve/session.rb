module Rserve
  class Session
    # serial version UID should only change if method signatures change
    # significantly enough that previous versions cannot be used with
    # current versions
    include Rserve::Protocol
    UID=-7048099825974875604
    attr_reader :host
    attr_reader :port
    attr_reader :key
    attr_reader :attach_packet
    attr_reader :rsrv_version
    def initialize(con,packet)
      @host=con.hostname
      @rsrv_version=con.rsrv_version
      ct=packet.cont
      if ct.nil? or ct.length!=32+3*4
        raise "Invalid response to session detach request."
      end
      @port=get_int(ct,4)
      @key=ct[12,32]
    end
    def attach
      c=Rserve::Connection.new(:session=>self)
      @attach_packet=c.rt.request(:cmd=>-1,:cont=>[])
      c
    end
  end
end