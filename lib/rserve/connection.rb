module Rserve
  class Connection < Rserve::Engine
    include Rserve::Protocol
    ServerNotInstalled=Class.new(Exception)
    IncorrectServer=Class.new(Exception)
    IncorrectServerVersion=Class.new(Exception)
    IncorrectProtocol=Class.new(Exception)
    NotConnected=Class.new(Exception)
    EvalError=Class.new(Exception)
    attr_reader :protocol 
    attr_reader :last_error
    attr_reader :connected
    attr_reader :auth_req
    attr_reader :auth_type
    attr_reader :key
    attr_reader :rt
    attr_reader :s
    attr_reader :port
    attr_writer :transfer_charset
    attr_reader :rsrv_version
    AT_plain=0
    AT_crypt=1
    
    def host
      @hostname
    end
    def initialize(opts=Hash.new)
      @auth_req=false
      @transfer_charset="UTF-8"
      @auth_type=AT_plain
      @hostname="127.0.0.1"
      @port_number=6311
      @tries=0
      @max_tries=5
      begin 
        #puts "Tryin to connect..."
        connect
      rescue Errno::ECONNREFUSED
        if @tries<@max_tries
          #puts "Init RServe"
          if system "R CMD Rserve"
          #puts "Ok"
            retry
	  else
	    raise ServerNotInstalled, "Rserve not installed"
	  end
        else
          raise
        end
      end
      
    end
    def is
      @s
    end
    def os
      @s
    end
    def connect
        close if @connected
        @s = TCPSocket::new(@hostname, @port_number)
        @rt=Rserve::Talk.new(@s)
        #puts "Connected"
        # Accept first input
        input=@s.recv(32).unpack("a4a4a4a20")
        raise IncorrectServer,"Handshake failed: Rsrv signature expected, but received #{input[0]}" unless input[0]=="Rsrv"
        @rsrv_version=input[1]
        raise IncorrectServerVersion, "Handshake failed: The server uses more recent protocol than this client." if @rsrv_version>"0103"
        @protocol=input[2]
        raise IncorrectProtocol, "Handshake failed: unsupported transfer protocol #{@protocol}, I talk only QAP1." if @protocol!="QAP1"
        @extra=input[4]
        @connected=true
        @last_error="OK"

    end
    def connected?
      @connected
    end
    def close
      begin
        s.shutdown if !s.nil? and !@s.closed?
        @connected=false
        return true
      rescue =>e
        return false
      end
    end
    def get_server_version
      @rsrv_version
    end
    
    # evaluates the given command, but does not fetch the result (useful for assignment operations)
    # * @param cmd command/expression string */
    def void_eval(cmd) 
      raise NotConnected if !connected? or rt.nil?
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_voidEval, :cont=>cmd+"\n")
      
      if !rp.nil? and rp.ok?
        true
      else
        raise EvalError, "voidEval failed: #{rp.to_s}"
      end
      
    end
    
    
    
    
    
    
    
    # Raw send of data
    def __send(com, data)
      bcom=command com, data
      @s.write(bcom)
      input=@s.recv(4)
      input=input.unpack("I")[0]
      raise "Incorrect response" unless input & CMD_RESP>0
      response=input & 0x00FFFFFF
      code= input >> 24
      if response == Rserve::RESP_OK
        if com==Rserve::CMD_eval # read response
          header=@s.recv(3).unpack("CCC")
          length=header[0]+header[1]*256+header[2]*(256*256)
          p @s.recv(length)
        elsif command==Rserve::CMD_readFile
          raise "Not implemented"
        end
      end
      {:response=>response,:code=>code}
  end
end
end