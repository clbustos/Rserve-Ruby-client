module Rserve
  # class providing TCP/IP connection to an Rserve
  class Connection < Rserve::Engine
    @@connected_object=nil
    include Rserve::Protocol

    # :section: Errors
    RserveNotStartedError=Class.new(StandardError)
    ServerNotAvailableError=Class.new(StandardError)
    IncorrectServerError=Class.new(StandardError)
    IncorrectServerVersionError=Class.new(StandardError)
    IncorrectProtocolError=Class.new(StandardError)
    IncorrectCredentialsError=Class.new(StandardError)
    NotConnectedError=Class.new(StandardError)
    # Eval error
    class EvalError < RuntimeError
      attr_accessor :request_packet
      def initialize(rp)
        @request_packet=rp
      end
    end
    attr_reader :hostname
    attr_reader :port_number
    attr_reader :protocol
    attr_reader :last_error
    attr_reader :connected
    attr_reader :auth_req
    attr_reader :auth_type
    attr_reader :key
    attr_reader :rt
    attr_reader :s
    attr_reader :port
    attr_reader :session
    attr_writer :transfer_charset
    attr_reader :rsrv_version
    attr_writer :persistent
    # authorization type: plain text
    AT_plain=0
    # authorization type: unix crypt
    AT_crypt=1
    # Make a new local connection 
    # You could provide a hash with options. Options are analog to java client:
    # [+:auth_req+]           If authentification is required (false by default)
    # [+:transfer_charset+]   Transfer charset ("UTF-8" by default)
    # [+:auth_type+]          Type of authentication (AT_plain by default)
    # [+:hostname+]           Hostname of Rserve ("127.0.0.1" by default)
    # [+:port_number+]        Port Number of Rserve (6311 by default)
    # [+:max_tries+]          Maximum number of tries before give up  (5 by default)
    # [+:cmd_init+]           Command to init Rserve if not initialized ("R CMD Rserve" by default)
    # [+:proc_rserve_ok+]     Proc testing if Rserve works (uses system by default)
    # [+:username+]           Username to use (if authentication is required)
    # [+:password+]           Password to use (if authentication is required)
    def initialize(opts=Hash.new)
      @auth_req         = opts.delete(:auth_req)          || false
      @transfer_charset = opts.delete(:transfer_charset)  || "UTF-8"
      @auth_type        = opts.delete(:auth_type)         || AT_plain
      @hostname         = opts.delete(:hostname)          || "127.0.0.1"
      @port_number      = opts.delete(:port_number)       || 6311
      @max_tries        = opts.delete(:max_tries)         || 5
      @cmd_init         = opts.delete(:cmd_init)          || "R CMD Rserve"
      @proc_rserve_ok   = opts.delete(:proc_rserve_ok)    || lambda { system "killall -s 0 Rserve" } 
      @username         = opts.delete(:username)          || nil
      @password         = opts.delete(:password)          || nil
      @session          = opts.delete(:session)           || nil
      @tries            = 0
      @connected=false
      if (!@session.nil?)
        @hostname=@session.host
        @port_number=@session.port
      end
      begin
        #puts "Tryin to connect..."
        connect
      rescue Errno::ECONNREFUSED
        if @tries<@max_tries
          @tries+=1
          # Rserve is available?
          if @proc_rserve_ok.call
            # Rserve is available. Incorrect host and/or portname
            raise ServerNotAvailableError, "Rserve started, but not available on #{hostname}:#{port_number}"
            # Rserve not available. We should instanciate it first
          else
            if run_server
              # Wait a moment, please
              sleep(0.25)
              retry
            else
              raise RserveNotStartedError, "Can't start Rserve"
            end
          end
          #puts "Init RServe"

        else
          raise
        end
      end
    end
    
    
    def connect
      # On windows, Rserve doesn't allows concurrent connections. 
      # So, we must close the last open connection first
      if ON_WINDOWS and !@@connected_object.nil?
        @@connected_object.close
      end

      close if @connected
      
      @s = TCPSocket::new(@hostname, @port_number)
      @rt=Rserve::Talk.new(@s)
      if @session.nil?
        #puts "Connected"
        # Accept first input
        input=@s.recv(32).unpack("a4a4a4a4a4a4a4a4")      
        raise IncorrectServerError, "Handshake failed: Rsrv signature expected, but received [#{input[0]}]" unless input[0]=="Rsrv"
        @rsrv_version=input[1].to_i
        raise IncorrectServerVersionError, "Handshake failed: The server uses more recent protocol than this client." if @rsrv_version>103
        @protocol=input[2]
        raise IncorrectProtocolError, "Handshake failed: unsupported transfer protocol #{@protocol}, I talk only QAP1." if @protocol!="QAP1"
        (3..7).each do |i|
          attr=input[i]
          if (attr=="ARpt") 
            @auth_req=true
          elsif (attr=="ARuc") 
            @auth_req=true
            @auth_type=AT_crypt
          elsif (attr[0..0]=='K') 
            @key=attr[1,2]
          end
        end
        login if auth_req
      else # we have a session to take care of
        @s.write(@session.key.pack("C*"))
        @rsrv_version=session.rsrv_version
      end
      @connected=true
      @@connected_object=self
      @last_error="OK"
    end
    # Check connection state. Note that currently this state is not checked on-the-spot, that is if connection went down by an outside event this is not reflected by the flag.
    # return +true+ if this connection is alive 
    def connected?
      @connected
    end
    
    # This server requires a login. Send the required credentials to the server.
    def login
      raise IncorrectCredentialsError, "Need username and password to connect" if @username.nil? || @password.nil?
      @password = @password.crypt(key) if key && auth_type == AT_crypt
      rp = @rt.request({:cmd => Rserve::Protocol::CMD_login, :cont => "#{@username}\n#{@password}"})
      raise IncorrectCredentialsError, "Server did not accept credentials" if rp.error?
    end
    
    # Closes current connection
    def close
      if !@s.nil? and !@s.closed?
        @s.close_write
        @s.close_read
      end
      raise "Can't close socket" unless @s.closed?
      @connected=false
      @@connected_object=nil
      true
    end
    # Get server version as reported during the handshake.
    def get_server_version
      @rsrv_version
    end

    # evaluates the given command, but does not fetch the result (useful for assignment operations)
    # * @param cmd command/expression string */
    def void_eval(cmd)
      raise NotConnectedError if !connected? or rt.nil?
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_voidEval, :cont=>cmd+"\n")
      if !rp.nil? and rp.ok?
        true
      else
        raise EvalError.new(rp), "voidEval failed: #{rp.to_s}"
      end

    end

    
    # Evaluates the given command, detaches the session (see detach()) and closes connection while the command is being evaluted (requires Rserve 0.4+).
    # Note that a session cannot be attached again until the commad was successfully processed. Technically the session is put into listening mode while the command is being evaluated but accept is called only after the command was evaluated. One commonly used techique to monitor detached working sessions is to use second connection to poll the status (e.g. create a temporary file and return the full path before detaching thus allowing new connections to read it).
		# * @param cmd command/expression string.
		# * @return session object that can be use to attach back to the session once the command completed 
    def void_eval_detach(cmd)
      raise NotConnectedError if !connected? or rt.nil?
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_detachedVoidEval,:cont=>cmd+"\n")
      if rp.nil? or !rp.ok?
        raise EvalError.new(rp), "detached void eval failed : #{rp.to_s}"
      else
        s=Rserve::Session.new(self,rp)
        close
        s
      end
    end



    # evaluates the given command and retrieves the result
    # * @param cmd command/expression string
    # * @return R-xpression or <code>null</code> if an error occured */
    def eval(cmd)
      raise NotConnectedError if !connected? or rt.nil?
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_eval, :cont=>cmd+"\n")
      if !rp.nil? and rp.ok?
        parse_eval_response(rp)
      else
        raise EvalError.new(rp), "eval failed: #{rp.to_s}"
      end
    end

    # NOT TESTED
    def parse_eval_response(rp)
      rxo=0
      pc=rp.cont
      if (rsrv_version>100) # /* since 0101 eval responds correctly by using DT_SEXP type/len header which is 4 bytes long */
        rxo=4
        # we should check parameter type (should be DT_SEXP) and fail if it's not
        if pc.nil?
          raise "Error while processing eval output: SEXP (type #{Rserve::Protocol::DT_SEXP}) expected but nil returned"
        elsif (pc[0]!=Rserve::Protocol::DT_SEXP and pc[0]!=(Rserve::Protocol::DT_SEXP|Rserve::Protocol::DT_LARGE))
          raise "Error while processing eval output: SEXP (type #{Rserve::Protocol::DT_SEXP}) expected but found result type "+pc[0].to_s+"."
        end
        
        if (pc[0]==(Rserve::Protocol::DT_SEXP|Rserve::Protocol::DT_LARGE))
          rxo=8; # large data need skip of 8 bytes
        end
        # warning: we are not checking or using the length - we assume that only the one SEXP is returned. This is true for the current CMD_eval implementation, but may not be in the future. */
      end
      if pc.length>rxo
        rx=REXPFactory.new;
        rx.parse_REXP(pc, rxo);
        return rx.get_REXP();
      else
        return nil
      end
    end

    #assign a string value to a symbol in R. The symbol is created if it doesn't exist already.
    # @param sym symbol name. Currently assign uses CMD_setSEXP command of Rserve, i.e. the symbol value is NOT parsed. It is the responsibility of the user to make sure that the symbol name is valid in R (recall the difference between a symbol and an expression!). In fact R will always create the symbol, but it may not be accessible (examples: "bar\nfoo" or "bar$foo").
    # @param ct contents
    def assign(sym, ct)
      raise NotConnectedError if !connected? or rt.nil?
      case ct
      when String
        assign_string(sym,ct)
      when REXP
        assign_rexp(sym,ct)
      else
        assign_rexp(sym, Rserve::REXP::Wrapper.wrap(ct))
      end
    end
    
    def assign_string(sym,ct)
      symn = sym.unpack("C*")
      ctn  = ct.unpack("C*")
      sl=symn.length+1
      cl=ctn.length+1
      sl=(sl&0xfffffc)+4 if ((sl&3)>0)  # make sure the symbol length is divisible by 4
      cl=(cl&0xfffffc)+4 if ((cl&3)>0)  # make sure the content length is divisible by 4
      rq=Array.new(sl+4+cl+4)
      symn.length.times {|i| rq[i+4]=symn[i]}
      ic=symn.length
      while (ic<sl)
        rq[ic+4]=0
        ic+=1
      end
      ctn.length.times {|i| rq[i+sl+8]=ctn[i]}
      ic=ctn.length
      while (ic<cl)
        rq[ic+sl+8]=0
        ic+=1
      end
      set_hdr(Rserve::Protocol::DT_STRING,sl,rq,0)
      set_hdr(Rserve::Protocol::DT_STRING,cl,rq,sl+4)
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_setSEXP,:cont=>rq)
      if (!rp.nil? and rp.ok?)
        rp
      else
        raise "Assign Failed"
      end
    end
    def assign_rexp(sym, rexp)
      r = REXPFactory.new(rexp);
      rl=r.get_binary_length();
      symn=sym.unpack("C*");
      sl=symn.length+1;
      sl=(sl&0xfffffc)+4 if ((sl&3)>0) # make sure the symbol length is divisible by 4
      rq=Array.new(sl+rl+((rl>0xfffff0) ? 12 : 8));
      symn.length.times {|i| rq[i+4]=symn[i]}
      ic=symn.length
      while(ic<sl)
        rq[ic+4]=0;
        ic+=1;
      end # pad with 0

      set_hdr(Rserve::Protocol::DT_STRING,sl,rq,0)
      set_hdr(Rserve::Protocol::DT_SEXP,rl,rq,sl+4);
      r.get_binary_representation(rq, sl+((rl>0xfffff0) ? 12 : 8));
      # puts "ASSIGN RQ: #{rq}" if $DEBUG
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_setSEXP, :cont=>rq)
      if (!rp.nil? and rp.ok?)
        rp
      else
        raise "Assign Failed"
      end
    end
    
    
    # Shutdown remote Rserve.
    # Note that some Rserves cannot be shut down from the client side
    def shutdown
      raise NotConnectedError if !connected? or rt.nil?
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_shutdown)
      if !rp.nil? and rp.ok? 
        true
      else
        raise "Shutdown failed"
      end
    end
    
    # Detaches the session and closes the connection (requires Rserve 0.4+).
    # The session can be only resumed by calling RSession.attach
    def detach
      raise NotConnectedError if !connected? or rt.nil?
      rp=rt.request(:cmd=>Rserve::Protocol::CMD_detachSession)
      if !rp.nil? and rp.ok? 
        s=Rserve::Session.new(self,rp)
        close
        s
      else
        raise "Cannot detach"
      end
    end

    private

      def run_server
        if RUBY_PLATFORM != "java"
          system @cmd_init
        else
          pid = Spoon.spawnp *@cmd_init.split
          return false if pid < 0
          Process.waitpid pid
          true
        end
      end

  end
end
