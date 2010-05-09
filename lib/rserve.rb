require 'socket'
module Rserve
  VERSION = '1.0.0'
  
  class Connection
    include Rserve::Protocol
  
    IncorrectServer=Class.new(Exception)
    IncorrectServerVersion=Class.new(Exception)
    IncorrectProtocol=Class.new(Exception)
    
    attr_reader :server_version, :protocol 
    def initialize(opts=Hash.new)
      @hostname="localhost"
      @port_number=6311
      @tries=0
      @max_tries=5
      begin 
        puts "Tryin to connect..."
        connect
      rescue Errno::ECONNREFUSED
        if @tries<@max_tries
          puts "Init RServe"
          system "R CMD Rserve"
          puts "Ok"
          retry
        else
          raise
        end
      end
      
    end

    def connect
        @socket = TCPSocket::new(@hostname, @port_number)
        puts "Connected"
        # Accept first input
        input=@socket.recv(32).unpack("a4a4a4a20")
        raise IncorrectServer,"Handshake failed: Rsrv signature expected, but received #{input[0]}" unless input[0]=="Rsrv"
        @server_version=input[1]
        raise IncorrectServerVersion, "Handshake failed: The server uses more recent protocol than this client." if @server_version>"0103"
        @protocol=input[2]
        raise IncorrectProtocol, "Handshake failed: unsupported transfer protocol #{@protocol}, I talk only QAP1." if @protocol!="QAP1"
        @extra=input[4]
    end
    def quit
      @socket.shutdown unless @socket.closed?
    end

    # Raw send of data
    def send(com, data)
      bcom=command com, data
      @socket.write(bcom)
      input=@socket.recv(4)
      input=input.unpack("I")[0]
      raise "Incorrect response" unless input & CMD_RESP>0
      response=input & 0x00FFFFFF
      code= input >> 24
      if response == Rserve::RESP_OK
        if com==Rserve::CMD_eval # read response
          header=@socket.recv(3).unpack("CCC")
          length=header[0]+header[1]*256+header[2]*(256*256)
          p @socket.recv(length)
        elsif command==Rserve::CMD_readFile
          raise "Not implemented"
        end
      end
      {:response=>response,:code=>code}
      
    end
  end
end
