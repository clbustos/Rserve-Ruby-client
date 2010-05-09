module Rserve
  # Class which 'talk' to the server.
  #
  # I separated the 'abstract' aspect of the protocol on
  # Protocol module, for better testing
  # 
  class Talk
    include Rserve::Protocol
    attr_reader :io
    def initialize(io)
      @io=io
    end
    # sends a request with attached prefix and  parameters.
    # All parameters should be enter on Hash
    # Both :prefix and :cont can be <code>nil</code>. Effectively <code>request(:cmd=>a,:prefix=>b,:cont=>nil)</code> and <code>request(:cmd=>a,:prefix=>nil,:cont=>b)</code> are equivalent.
    # @param :cmd command - a special command of -1 prevents request from sending anything
    # @param :prefix - this content is sent *before* cont. It is provided to save memory copy operations where a small header precedes a large data chunk (usually prefix conatins the parameter header and cont contains the actual data).
    # @param :cont contents
    # @param :offset offset in cont where to start sending (if <0 then 0 is assumed, if >cont.length then no cont is sent)
    # @param :len number of bytes in cont to send (it is clipped to the length of cont if necessary)
    # @return returned packet or <code>null</code> if something went wrong */
    def request(params=Hash.new)
       
        cmd     = params.delete :cmd
        prefix  = params.delete :prefix
        cont    = params.delete :cont
        offset  = params.delete :offset
        len     = params.delete :len
        
        raise ArgumentError, ":cont should be an Enumerable" if !cont.nil? and !cont.is_a? Enumerable
        if len.nil? 
          len=(cont.nil?) ? 0 : cont.length
        end
        offset||=0
        
      
      if (!cont.nil?) 
        if (offset>=cont.length) 
          cont=nil;len=0
        elsif (len>cont.length-offset)
          len=cont.length-offset
        end
      end
      offset=0 if offset<0
      len=0 if len<0
      contlen=(cont.nil?) ? 0 : len
      contlen+=prefix.length if (!prefix.nil? and prefix.length>0) 
      
      hdr=Array.new(16)
      set_int(cmd,hdr,0)
      set_int(contlen,hdr,4);
      8.upto(15) {|i| hdr[i]=0}
      
      
        if (cmd!=-1)
          io.write(hdr.pack("C*"));
          io.write(prefix.pack("C*")) if (!prefix.nil? && prefix.length>0)
          io.write(cont.slice(offset,len).pack("C*")) if (!cont.nil? && cont.length>0)
        end
        
        ih=io.recv(16).unpack("C*")
        return nil if (ih.length!=16)
        
        rep=get_int(ih,0);
        rl =get_int(ih,4);
        if (rl>0)
          ct=Array.new();
          n=0;
          while (n<rl) do
            data=io.recv(rl-n).unpack("C*")
            ct+=data
            rd=data.length
            n+=rd;
          end
          return Packet.new(rep,ct);
        end
        return Packet.new(rep,nil);
    end
  end
end

